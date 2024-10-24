module Import
  module DigitalRemaster
    module Builders
      class OrchestraBuilder
        class UnrecognizedRoleError < StandardError; end

        EXCLUDE_ROLES = ["arranger", "author", "composer", "director"].freeze

        ROLE_TRANSLATION = {
          "piano" => "pianist",
          "arranger" => "arranger",
          "doublebass" => "double-bassist",
          "bandoneon" => "bandoneonist",
          "violin" => "violinist",
          "singer" => "vocalist",
          "soloist" => "soloist",
          "cello" => "cellist",
          "viola" => "violist"
        }.freeze

        def initialize(orchestra_name:, el_recodo_song: nil)
          @orchestra_name = orchestra_name
          @el_recodo_song = el_recodo_song
        end

        def build
          orchestra = Orchestra.find_or_initialize_by(name: @orchestra_name) do |orchestra|
            if @el_recodo_song&.orchestra.present?
              orchestra.el_recodo_orchestra = @el_recodo_song.el_recodo_orchestra
            end
          end

          if !orchestra.image.attached? && @el_recodo_song&.orchestra&.image&.attached?
            orchestra.image.attach(@el_recodo_song.orchestra.image.blob)
          end

          if @el_recodo_song.present?
            @el_recodo_song.person_roles.each do |person_role|
              role = person_role.role.downcase

              next if EXCLUDE_ROLES.include?(role)

              role_name = ROLE_TRANSLATION[role]
              raise UnrecognizedRoleError, "Unrecognized role: #{person_role.role}" unless role_name

              person = find_or_create_person_with_image(person_role.person.name)
              orchestra_role = OrchestraRole.find_or_create_by!(name: role_name)

              OrchestraPosition.find_or_create_by!(
                orchestra:,
                orchestra_role:,
                person:
              )
            end
          end

          orchestra.save!
          orchestra
        end

        private

        def find_or_create_person_with_image(name)
          person = Person.find_or_create_by_normalized_name!(name)
          el_recodo_person = ExternalCatalog::ElRecodo::Person.search(name).first

          if el_recodo_person&.image&.attached? && !person.image.attached?
            person.image.attach(el_recodo_person.image.blob)
          end

          person
        end
      end
    end
  end
end
