require "active_support/core_ext/string/inflections"

module ExternalCatalog
  module ElRecodo
    class SongScraper
      class TooManyRequestsError < StandardError; end

      class PageNotFoundError < StandardError; end

      class EmptyPageError < StandardError; end

      Metadata = Data.define(
        :ert_number,
        :date,
        :title,
        :style,
        :label,
        :matrix,
        :disk,
        :instrumental,
        :speed,
        :duration,
        :lyrics,
        :lyrics_year,
        :synced_at,
        :page_updated_at
      ).freeze

      Person = Data.define(
        :name,
        :role,
        :url
      ).freeze

      Tag = Data.define(
        :name,
        :url
      ).freeze

      Result = Data.define(
        :metadata,
        :musicians,
        :people,
        :lyricist,
        :tags
      ).freeze

      def initialize(connection)
        @connection = connection.connection
      end

      def fetch(ert_number:)
        response = @connection.get("https://www.el-recodo.com/music?id=#{ert_number}&lang=en")

        # If the page is empty, it means the song doesn't exist for that ert_number
        if response.status == 302
          raise EmptyPageError
        end

        parsed_page = Nokogiri::HTML(response.body)

        metadata = Metadata.new(
          ert_number: extract_ert_number(parsed_page),
          date: safe_parse_date(extract_text(parsed_page, "DATE")),
          title: extract_text(parsed_page, "TITLE"),
          style: extract_text(parsed_page, "STYLE")&.titleize,
          label: extract_text(parsed_page, "LABEL"),
          matrix: extract_text(parsed_page, "MATRIX"),
          disk: extract_text(parsed_page, "DISK"),
          instrumental: extract_text(parsed_page, "SINGER") == "Instrumental",
          speed: extract_text(parsed_page, "SPEED"),
          duration: convert_duration_to_seconds(extract_text(parsed_page, "DURATION")),
          lyrics: extract_lyrics(parsed_page),
          lyrics_year: extract_lyrics_year(parsed_page),
          synced_at: Time.zone.now,
          page_updated_at: extract_page_updated_at(parsed_page)
        )

        musicians = extract_musicians(parsed_page)
        people = extract_people(parsed_page)
        lyricist = extract_lyricist(parsed_page)
        tags = extract_tags(parsed_page)

        Result.new(metadata:, musicians:, people:, lyricist:, tags:)
      rescue Faraday::ResourceNotFound
        raise PageNotFoundError
      rescue Faraday::TooManyRequestsError
        raise TooManyRequestsError
      end

      private

      def extract_text(parsed_page, keyword)
        element = parsed_page.css(".list-group.lead a:contains('#{keyword}')").first
        element&.children&.last&.text&.strip
      end

      def extract_ert_number(parsed_page)
        text = parsed_page.at_css(".text-secondary small")&.text
        text&.split(": ERT-")&.last&.strip&.to_i
      end

      def extract_lyrics(parsed_page)
        lyrics_element = parsed_page.at_css("#geniusText")
        return "" unless lyrics_element

        lyrics_element.text.strip
      end

      def extract_lyrics_year(parsed_page)
        cite_element = parsed_page.at_css("#geniusText + * cite")
        return nil unless cite_element

        year_match = cite_element.text.match(/\((\d{4})\)/)
        year_match ? year_match[1].to_i : nil
      end

      def extract_lyricist(parsed_page)
        cite_element = parsed_page.at_css("#geniusText + * cite a")
        return nil unless cite_element

        Person.new(
          name: cite_element.text.strip.gsub(/\s+/, " ")&.titleize,
          url: cite_element["href"],
          role: "lyricist"
        )
      end

      def extract_page_updated_at(parsed_page)
        date_string = parsed_page.css("p.text-muted.small.mb-0")&.text&.split(": ")&.last

        return nil unless date_string

        DateTime.parse(date_string)
      end

      def safe_parse_date(date_string)
        return nil unless date_string

        year, month, day = date_string.split("-")
        month = "01" if month == "00"
        day = "01" if day == "00"

        Date.new(year.to_i, month.to_i, day.to_i)
      rescue ArgumentError => e
        Rails.logger.error("El Recodo Song Scraper: #{e.message}")
        raise e
      end

      def extract_musicians(parsed_page)
        musicians_section = parsed_page.at_css("#musicians")&.next_element
        return [] unless musicians_section

        musicians = []

        possible_instruments = ["PIANO", "DOUBLEBASS", "BANDONEON", "VIOLIN", "ARRANGER"]
        current_role = nil
        collecting_musicians = false
        musician_names = []

        musicians_section.css(".card-body").children.each do |node|
          if node.text? && possible_instruments.any? { |instrument| node.text.include?("#{instrument}:") }
            current_role, _ = node.text.split(":", 2).map(&:strip)
            collecting_musicians = true
          elsif node.name == "br"
            if collecting_musicians && current_role
              musician_names.each do |link|
                musician_name = link.text.strip.gsub(/\s+/, " ")&.titleize
                musician_url = link["href"]
                musicians << Person.new(name: musician_name, url: musician_url, role: current_role.downcase)
              end
            end
            current_role = nil
            collecting_musicians = false
            musician_names.clear
          elsif collecting_musicians && node.name == "a"
            musician_names << node
          end
        end

        if collecting_musicians && current_role
          musician_names.each do |link|
            musician_name = link.text.strip.gsub(/\s+/, " ")&.titleize
            musician_url = link["href"]
            musicians << Person.new(name: musician_name, url: musician_url, role: current_role.downcase)
          end
        end

        musicians
      end

      def extract_people(parsed_page)
        roles = ["ORCHESTRA", "SINGER", "COMPOSER", "AUTHOR", "SOLOIST", "DIRECTOR"]
        people = []

        roles.each do |role|
          parsed_page.css(".list-group.lead a:contains('#{role}')").each do |link|
            person_text = link.text.strip
            person_url = link["href"]

            person_name = person_text.gsub(/^#{role}\s*/i, "").strip.gsub(/\s+/, " ")

            # Remove "Dir." if it exists and titleize the name
            person_name.gsub!(/^Dir\.\s*/i, "")

            person_name.split(" y ").each do |name|
              people << Person.new(name: format_name(person_name), url: person_url, role: role.downcase)
            end
          end
        end

        people
      end

      def extract_tags(parsed_page)
        tags = []
        parsed_page.css(".list-group-item.mb-0 li.list-inline-item a").each do |tag_link|
          tag_name = tag_link.text.strip.gsub(/\s+/, " ")&.titleize
          tag_url = tag_link["href"]
          tags << Tag.new(name: tag_name, url: tag_url)
        end
        tags
      end

      def convert_duration_to_seconds(duration_str)
        return nil unless duration_str

        minutes, seconds = duration_str.split(":").map(&:to_i)
        minutes * 60 + seconds
      end

      def format_name(name)
        # Juan D'ARIENZO => Juan D'Arienzo
        name.split(/(\s|')/).map(&:capitalize).join
      end
    end
  end
end
