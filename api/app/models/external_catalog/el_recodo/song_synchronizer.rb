module ExternalCatalog
  module ElRecodo
    class SongSynchronizer
      def initialize(connection)
        @connection = connection.connection
      end

      def sync_song(ert_number:)
        scraper = SongScraper.new(@connection)
        song_data = scraper.fetch(ert_number:)

        ActiveRecord::Base.transaction do
          song = ElRecodoSong.find_or_initialize_by(ert_number:)
          song.update!(
            ert_number: song_data.metadata.ert_number,
            title: song_data.metadata.title,
            date: song_data.metadata.date,
            style: song_data.metadata.style,
            label: song_data.metadata.label,
            matrix: song_data.metadata.matrix,
            disk: song_data.metadata.disk,
            instrumental: song_data.metadata.instrumental,
            speed: song_data.metadata.speed,
            duration: song_data.metadata.duration,
            lyrics: song_data.metadata.lyrics,
            lyrics_year: song_data.metadata.lyrics_year,
            synced_at: song_data.metadata.synced_at,
            page_updated_at: song_data.metadata.page_updated_at
          )

          sync_people(song, song_data.people)
        end
      end

      private

      def sync_people(song, people)
        people.each do |person_data|
          person = ElRecodoPerson.find_or_initialize_by(name: person_data.name)
          person.update!(
            name: person_data.name,
            real_name: person_data.real_name,
            nicknames: person_data.nicknames,
            place_of_birth: person_data.place_of_birth,
            birth_date: person_data.birth_date,
            death_date: person_data.death_date,
            url: person_data.url,
            image_url: person_data.image_url
          )

          ElRecodoPersonRole.find_or_create_by!(
            song:,
            person:,
            role: person_data.role
          )
        end
      end

      def find_person_by_role(people, role)
        person = people.find { |p| p.role == role }
        person&.name
      end
    end
  end
end
