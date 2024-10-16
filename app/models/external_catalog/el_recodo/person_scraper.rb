module ExternalCatalog
  module ElRecodo
    class PersonScraper
      class TooManyRequestsError < StandardError; end

      class PageNotFoundError < StandardError; end

      class ServerError < StandardError; end

      BASE_URL = "https://www.el-recodo.com".freeze

      Person = Data.define(
        :name,
        :birth_date,
        :death_date,
        :real_name,
        :nicknames,
        :place_of_birth,
        :path,
        :image_path
      ).freeze

      def initialize(cookies: nil)
        @cookies = cookies || Auth.new.cookies
        @connection = Faraday.new(url: BASE_URL) do |faraday|
          faraday.headers["Cookie"] = @cookies
          faraday.response :follow_redirects
          faraday.use :cookie_jar
          faraday.response :raise_error
        end
      end

      def fetch(path:)
        sleep Rails.application.credentials.dig(:el_recodo_request_delay).to_i

        response = @connection.get(path)

        body = response.body.force_encoding("UTF-8")
        doc = Nokogiri::HTML(body)

        person_details_section = doc.css(".row.mb-3")
        header = person_details_section&.css("h1")&.first
        person_details = person_details_section&.css(".col")&.first&.children
        image_element = person_details_section&.css("img.rounded.img-fluid")&.first

        Person.new(
          name: parse_name(header),
          birth_date: parse_birth_date(person_details),
          death_date: parse_death_date(person_details),
          real_name: parse_real_name(person_details),
          nicknames: parse_nicknames(person_details),
          place_of_birth: parse_place_of_birth(person_details),
          path:,
          image_path: parse_image_path(image_element)
        )
      rescue Faraday::ResourceNotFound
        raise PageNotFoundError
      rescue Faraday::TooManyRequestsError
        raise TooManyRequestsError
      rescue Faraday::ServerError
        raise ServerError
      end

      private

      def parse_name(header)
        return unless header

        format_name(header.children.last.text.strip)
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

      def parse_birth_date(children)
        return unless children

        date_node = children.find { |node| node.text? && node.text.strip.match(/^\(\d{4}-\d{2}-\d{2}/) }
        date_str = date_node&.text&.match(/^\((\d{4}-\d{2}-\d{2}) -/)&.captures&.first

        safe_parse_date(date_str) if date_str
      end

      def parse_death_date(children)
        return unless children

        date_text_node = children.find { |node| node.text? && node.text.strip.gsub(/\s+/, " ").match(/^\(\d{4}-\d{2}-\d{2}/) }
        return unless date_text_node

        date_range_text = date_text_node.text.strip.match(/^\((\d{4}-\d{2}-\d{2})\s*-\s*(\d{4}-\d{2}-\d{2})\)$/)
        return unless date_range_text

        death_date_text = date_range_text[2]

        safe_parse_date(death_date_text) if death_date_text
      end

      def parse_real_name(children)
        return unless children

        real_name_node = children.find { |node| node.text? && node.text.include?("Real name:") }
        real_name_node&.text&.split("Real name:")&.last&.strip
      end

      def parse_nicknames(children)
        return [] unless children

        nicknames_node = children.find { |node| node.text? && node.text.include?("Nickname(s):") }
        nicknames = nicknames_node&.text&.split("Nickname(s):")&.last&.strip&.split(/ y |,|\//)&.map(&:strip)
        nicknames || []
      end

      def parse_place_of_birth(children)
        return unless children

        place_of_birth_node = children.find { |node| node.text? && node.text.include?("Place of birth:") }
        place_of_birth_node&.text&.split("Place of birth:")&.last&.strip
      end

      def parse_image_path(image_element)
        image_element&.attr("src")
      end

      def format_name(name)
        # Remove "Dir. " if it exists
        name.gsub!("Dir. ", "")
        # Juan D'ARIENZO => Juan D'Arienzo
        name.split(/(\s|')/).map(&:capitalize).join if name
      end
    end
  end
end
