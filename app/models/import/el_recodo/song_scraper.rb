# frozen_string_literal: true

module Import
  module ElRecodo
    class SongScraper
      class TooManyRequestsError < StandardError; end

      class PageNotFoundError < StandardError; end

      Metadata = Data.define(
        :date,
        :ert_number,
        :music_id,
        :title,
        :style,
        :orchestra,
        :singer,
        :composer,
        :author,
        :label,
        :lyrics,
        :synced_at,
        :page_updated_at
      ).freeze

      def initialize(music_id:)
        @music_id = music_id
      end

      def metadata
        Metadata.new(
          date:,
          ert_number:,
          music_id: @music_id,
          title:,
          style:,
          orchestra:,
          singer:,
          composer:,
          author:,
          label:,
          lyrics:,
          synced_at:,
          page_updated_at:
        )
      end

      private

      def faraday
        @faraday ||= Faraday.new do |conn|
          conn.headers["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15"
        end
      end

      def extract_info(keyword)
        element = parse_html.at_css("a:contains('#{keyword}')")
        element&.children&.last&.text&.strip
      end

      def orchestra
        @orchestra ||= extract_info("ORCHESTRA")
      end

      def title
        @title ||= extract_info("TITLE")
      end

      def date
        date_string = extract_info("DATE")
        safe_parse_date(date_string)
      end

      def style
        @style ||= extract_info("STYLE")
      end

      def singer
        @singer ||= extract_info("SINGER")
      end

      def composer
        @composer ||= extract_info("COMPOSER")
      end

      def author
        @author ||= extract_info("AUTHOR")
      end

      def label
        @label ||= extract_info("LABEL")
      end

      def ert_number
        text = parse_html.at_css(".text-secondary small")&.text
        text&.split(": ERT-")&.last&.strip&.to_i
      end

      def page_updated_at
        date_string = parse_html.css("p.text-muted.small.mb-0")&.text&.split(": ")&.last
        safe_parse_date(date_string)
      end

      def lyrics
        @lyrics ||= parse_html.css("#geniusText").text.strip
      end

      def synced_at
        @synced_at ||= Time.zone.now
      end

      def safe_parse_date(date_string)
        Date.parse(date_string)
      rescue ArgumentError, TypeError
        nil
      end

      def parse_html
        @parsed_html ||= Nokogiri::HTML(fetch_page.body)
      end

      def fetch_page
        begin
          response = faraday.get("https://www.el-recodo.com/music?id=#{@music_id}&lang=en")
          if response.status == 429
            Rails.logger.error("El Recodo Song Scraper: Too Many Requests")
            raise TooManyRequestsError
          elsif response.status != 200
            Rails.logger.error("El Recodo Song Scraper: Page Not Found")
            raise PageNotFoundError
          end
        rescue Faraday::Error => e
          Rails.logger.error("El Recodo Song Scraper: #{e.message}")
          raise
        end
        response
      end
    end
  end
end
