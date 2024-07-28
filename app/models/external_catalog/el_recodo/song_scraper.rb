require "active_support/core_ext/string/inflections"

module ExternalCatalog
  module ElRecodo
    class SongScraper
      BASE_URL = "https://www.el-recodo.com".freeze

      class TooManyRequestsError < StandardError; end

      class PageNotFoundError < StandardError; end

      Metadata = Data.define(
        :ert_number,
        :date,
        :title,
        :orchestra_name,
        :orchestra_image_path,
        :orchestra_path,
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
        :members,
        :tags
      ).freeze

      def initialize(cookies: nil)
        @cookies = cookies || Auth.new.cookies
        @connection = Faraday.new(url: BASE_URL) do |faraday|
          faraday.headers["Cookie"] = @cookies

          faraday.response :raise_error
        end
      end

      def fetch(ert_number:)
        sleep Config.el_recodo_request_delay.to_i

        response = @connection.get("https://www.el-recodo.com/music?id=#{ert_number}&lang=en")

        # If the page is empty, it means the song doesn't exist for that ert_number
        if response.status == 302
          EmptyPage.find_or_create_by!(ert_number:)
          return
        end

        parsed_page = Nokogiri::HTML(response.body)

        metadata = Metadata.new(
          ert_number: extract_ert_number(parsed_page),
          date: safe_parse_date(extract_text(parsed_page, "DATE")),
          title: extract_text(parsed_page, "TITLE"),
          orchestra_name: format_name(extract_text(parsed_page, "ORCHESTRA")),
          orchestra_image_path: extract_orchestra_image_path(parsed_page),
          orchestra_path: extract_link(parsed_page, "ORCHESTRA"),
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

        members = [people, musicians, lyricist].flatten.compact

        Result.new(metadata:, members:, tags:)
      rescue Faraday::ResourceNotFound
        sleep Config.el_recodo_request_delay.to_i
        raise PageNotFoundError
      rescue Faraday::TooManyRequestsError
        sleep Config.el_recodo_request_delay.to_i
        raise TooManyRequestsError
      rescue Faraday::ServerError
        sleep Config.el_recodo_request_delay.to_i
        nil
      end

      private

      def extract_text(parsed_page, keyword)
        element = parsed_page.css(".list-group.lead a:contains('#{keyword}')").first
        element&.children&.last&.text&.strip
      end

      def extract_link(parsed_page, keyword)
        element = parsed_page.css(".list-group.lead a:contains('#{keyword}')").first
        href = element&.attributes&.[]("href")&.value
        if href
          URI::DEFAULT_PARSER.escape(href)
        end
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
          url: URI::DEFAULT_PARSER.escape(cite_element["href"]),
          role: "lyricist"
        )
      end

      def extract_page_updated_at(parsed_page)
        date_string = parsed_page.css("p.text-muted.small.mb-0")&.text&.split(": ")&.last

        return nil unless date_string

        DateTime.parse(date_string) || nil
      end

      def safe_parse_date(date_string)
        return nil if date_string.blank?

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

        possible_instruments = ["PIANO", "DOUBLEBASS", "BANDONEON", "VIOLIN", "ARRANGER", "CELLO"]
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
                musicians << Person.new(
                  name: musician_name,
                  url: URI::DEFAULT_PARSER.escape(musician_url),
                  role: current_role.downcase
                )
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
            musicians << Person.new(
              name: musician_name,
              url: URI::DEFAULT_PARSER.escape(musician_url),
              role: current_role.downcase
            )
          end
        end

        musicians
      end

      def extract_people(parsed_page)
        roles = ["SINGER", "COMPOSER", "AUTHOR", "SOLOIST", "DIRECTOR"]
        people = []

        roles.each do |role|
          parsed_page.css(".list-group.lead a:contains('#{role}')").each do |link|
            person_text = link.text.strip
            person_url = link["href"]

            person_name = person_text.gsub(/^#{role}\s*/i, "").strip.gsub(/\s+/, " ")

            # Remove "Dir." if it exists and titleize the name
            person_name.gsub!(/^Dir\.\s*/i, "")

            # Split the name if it contains "y" or "Y"
            person_name.split(/ y | Y /).map(&:strip).each do |name|
              next if name == "Instrumental"

              people << Person.new(
                name: format_name(name),
                url: URI::DEFAULT_PARSER.escape(person_url),
                role: role.downcase
              )
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
          tags << Tag.new(
            name: tag_name,
            url: URI::DEFAULT_PARSER.escape(tag_url)
          )
        end
        tags
      end

      def extract_orchestra_image_path(parsed_page)
        main_metadata = parsed_page.at_css("h1").next_element
        image_element = main_metadata.css("img.rounded.img-fluid").first
        return nil unless image_element

        image_element["src"]
      end

      def convert_duration_to_seconds(duration_str)
        return nil unless duration_str

        minutes, seconds = duration_str.split(":").map(&:to_i)
        minutes * 60 + seconds
      end

      def format_name(name)
        return nil unless name
        # Juan D'ARIENZO => Juan D'Arienzo
        name.split(/(\s|')/).map(&:capitalize).join
      end
    end
  end
end
