module ExternalCatalog
  module ElRecodo
    class RoleManager
      BASE_URL = "https://www.el-recodo.com".freeze

      def initialize(cookies:)
        @cookies = cookies
        @person_scraper = PersonScraper.new(cookies: @cookies)
        @connection = Faraday.new(url: BASE_URL) do |faraday|
          faraday.headers["Cookie"] = cookies
          faraday.use(
            :throttler,
            rate: 20,
            wait: 60
          )
          faraday.use Faraday::Response::RaiseError
        end
      end

      def sync_people(el_recodo_song:, people:)
        people.map do |person_data|
          person = find_or_scrape_person(person_data)
          ElRecodoPersonRole.find_or_create_by!(
            el_recodo_song:,
            el_recodo_person: person,
            role: person_data.role.downcase
          )
        end
      end

      private

      def find_or_scrape_person(person_data)
        person = ElRecodoPerson.find_by(name: person_data.name)
        return person if person

        scraped_person_data = @person_scraper.fetch(path: person_data.url)

        person = ElRecodoPerson.create!(
          name: scraped_person_data.name,
          birth_date: scraped_person_data.birth_date,
          death_date: scraped_person_data.death_date,
          real_name: scraped_person_data.real_name,
          nicknames: scraped_person_data.nicknames,
          place_of_birth: scraped_person_data.place_of_birth,
          path: scraped_person_data.path
        )

        if scraped_person_data.image_path.present?
          response = @connection.get(scraped_person_data.image_path)

          io = StringIO.new(response.body)

          content_type = response.headers["content-type"]
          file_extension = Mime::Type.lookup(content_type).symbol.to_s
          filename = "#{scraped_person_data.name.parameterize}.#{file_extension}"

          person.image.attach(io:, filename:, content_type:)
        end

        person
      end
    end
  end
end
