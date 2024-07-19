module ExternalCatalog
  module ElRecodo
    class SongSynchronizer
      def initialize(cookies: nil, song_scraper: nil, role_manager: nil)
        @cookies = cookies || Auth.new.cookies
        @song_scraper = song_scraper || ExternalCatalog::ElRecodo::SongScraper.new(cookies: @cookies)
        @role_manager = role_manager || ExternalCatalog::ElRecodo::RoleManager.new(cookies: @cookies)
      end

      def sync_song(ert_number:)
        result = @song_scraper.fetch(ert_number:)

        ActiveRecord::Base.transaction do
          el_recodo_song = ElRecodoSong.find_or_initialize_by(ert_number:)
          el_recodo_song.update!(result.metadata.to_h)

          people = [result.people, result.musicians, result.lyricist]
          people.flatten!
          people.compact!
          binding.irb
          @role_manager.sync_people(
            el_recodo_song:,
            people:
          )
        end
      end
    end
  end
end
