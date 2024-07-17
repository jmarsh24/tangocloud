module ExternalCatalog
  module ElRecodo
    class PersonScraper
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

      def initialize(cookies:)
        @cookies = cookies
        @connection = Faraday.new(url: BASE_URL) do |faraday|
          faraday.headers["Cookie"] = cookies
        end
      end

      def fetch(path:)
        response = @connection.get(path)
        doc = Nokogiri::HTML(response.body)

        person_details = doc.css(".col").first
        header = doc.css("h1").first

        Person.new(
          name: parse_name(header),
          birth_date: parse_birth_date(person_details.children),
          death_date: parse_death_date(person_details.children),
          real_name: parse_real_name(person_details.children),
          nicknames: parse_nicknames(person_details.children),
          place_of_birth: parse_place_of_birth(person_details.children),
          path:,
          image_path: parse_image_path(doc)
        )
      end

      private

      def parse_name(header)
        format_name(header.children.last.text.strip)
      end

      def parse_birth_date(children)
        date_node = children.find { |node| node.text? && node.text.strip.match(/^\(\d{4}-\d{2}-\d{2}/) }
        date_str = date_node&.text&.match(/^\((\d{4}-\d{2}-\d{2}) -/)&.captures&.first

        Date.parse(date_str) if date_str
      end

      def parse_death_date(children)
        date_text_node = children.find { |node| node.text? && node.text.strip.gsub(/\s+/, " ").match(/^\(\d{4}-\d{2}-\d{2}/) }
        death_date_text = date_text_node.text.split("\n").last.strip.delete(")")

        Date.parse(death_date_text) if death_date_text
      end

      def parse_real_name(children)
        real_name_node = children.find { |node| node.text? && node.text.include?("Real name:") }
        real_name_node&.text&.split("Real name:")&.last&.strip
      end

      def parse_nicknames(children)
        nicknames_node = children.find { |node| node.text? && node.text.include?("Nickname(s):") }
        nicknames_node&.text&.split("Nickname(s):")&.last&.strip&.split(",")&.map(&:strip)
      end

      def parse_place_of_birth(children)
        place_of_birth_node = children.find { |node| node.text? && node.text.include?("Place of birth:") }
        place_of_birth_node&.text&.split("Place of birth:")&.last&.strip
      end

      def parse_image_path(doc)
        img_element = doc.css("img.rounded.img-fluid").first
        img_element&.attr("src")
      end

      def format_name(name)
        # Juan D'ARIENZO => Juan D'Arienzo
        name.split(/(\s|')/).map(&:capitalize).join
      end
    end
  end
end
