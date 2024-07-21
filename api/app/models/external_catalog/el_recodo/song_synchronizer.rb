module ExternalCatalog
  module ElRecodo
    class SongSynchronizer
      def initialize(cookies: nil, song_scraper: nil)
        @cookies = cookies || Auth.new.cookies
        @song_scraper = song_scraper || ExternalCatalog::ElRecodo::SongScraper.new(cookies: @cookies)
      end

      def sync_song(ert_number:)
        result = @song_scraper.fetch(ert_number:)
        metadata = result.metadata

        song = ExternalCatalog::ElRecodo::SongBuilder.new(cookies: @cookies).build_song(
          ert_number:,
          metadata:,
          people: result.people
        )

        song.save!
        song
      end
    end
  end
end
