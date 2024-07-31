module ExternalCatalog
  module ElRecodo
    class SongBuilder
      BASE_URL = "https://www.el-recodo.com".freeze

      def initialize(cookies: nil, person_scraper: nil)
        @cookies = cookies || Auth.new.cookies
        @person_scraper = person_scraper || PersonScraper.new(cookies: @cookies)
        @connection = Faraday.new(url: BASE_URL) do |faraday|
          faraday.headers["Cookie"] = cookies
          faraday.response :raise_error
        end
      end

      def build_song(ert_number:, metadata:, people:)
        orchestra = if metadata.orchestra_name.present?
          find_or_build_orchestra(name: metadata.orchestra_name, image_path: metadata.orchestra_image_path, path: metadata.orchestra_path)
        end

        song = Song.find_or_initialize_by(ert_number:).tap do |song|
          song.title = metadata.title
          song.orchestra = orchestra
          song.date = metadata.date
          song.style = metadata.style
          song.label = metadata.label
          song.matrix = metadata.matrix
          song.lyrics = metadata.lyrics
          song.lyrics_year = metadata.lyrics_year
          song.disk = metadata.disk
          song.instrumental = metadata.instrumental
          song.speed = metadata.speed
          song.duration = metadata.duration
          song.synced_at = metadata.synced_at
          song.page_updated_at = metadata.page_updated_at
        end

        people.each do |person_data|
          persons = find_or_build_people(person_data)

          persons.each do |person|
            song.person_roles.build(person:, role: person_data.role.downcase)
          end
        end

        song
      end

      def find_or_build_people(person_data)
        names = person_data.name.split(/ y | Y /).map(&:strip)
        names.flat_map do |name|
          person = Person.find_or_create_by!(name:) do |p|
            scraped_person_data = @person_scraper.fetch(path: person_data.url)

            p.assign_attributes(
              birth_date: scraped_person_data.birth_date,
              death_date: scraped_person_data.death_date,
              real_name: scraped_person_data.real_name,
              nicknames: scraped_person_data.nicknames,
              place_of_birth: scraped_person_data.place_of_birth,
              path: scraped_person_data.path
            )
            if scraped_person_data.image_path.present?
              attach_image(record: p, image_path: scraped_person_data.image_path)
            end
          end
          person
        end.compact
      end

      def find_or_build_orchestra(name:, path:, image_path: nil)
        orchestra = Orchestra.find_or_initialize_by(name:) do |o|
          o.path = path
        end

        if orchestra.new_record? && image_path.present?
          attach_image(record: orchestra, image_path:)
        end

        orchestra
      end

      def attach_image(record:, image_path:)
        response = @connection.get(image_path)
        if response.success?
          io = StringIO.new(response.body)
          content_type = response.headers["content-type"]
          file_extension = Mime::Type.lookup(content_type).symbol.to_s
          filename = "#{record.name.parameterize}.#{file_extension}"
          record.image.attach(io:, filename:, content_type:)
        end
        record.image
      end
    end
  end
end
