module Import
  module DigitalRemaster
    module Builders
      class SingerBuilder
        Singer = Data.define(:person, :soloist).freeze

        def initialize(name:)
          @name = name
        end

        def build
          return [] if @name.blank?

          @name.split(",").map(&:strip).filter_map do |name|
            next if name.casecmp("instrumental").zero?

            if name.start_with?("Dir. ")
              name = name.sub("Dir. ", "").strip
              person = find_or_create_person_with_image(name)
              Singer.new(person:, soloist: true)
            else
              person = find_or_create_person_with_image(name)
              Singer.new(person:, soloist: false)
            end
          end
        end

        private

        def find_or_create_person_with_image(name)
          person = Person.find_or_create_by_normalized_name!(name)
          el_recodo_person = ExternalCatalog::ElRecodo::Person.search(name).first

          if el_recodo_person&.image&.attached?
            person.image.attach(el_recodo_person.image.blob) unless person.image.attached?
          end

          person
        end
      end
    end
  end
end
