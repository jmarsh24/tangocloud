module Import
  module DigitalRemaster
    module Builders
      class OrchestraBuilder
        class UnrecognizedRoleError < StandardError; end

        EXCLUDE_ROLES = [
          "arranger",
          "author",
          "composer",
          "director"
        ].freeze

        ROLE_TRANSLATION = {
          "piano" => "Pianist",
          "arranger" => "Arranger",
          "doublebass" => "Double Bassist",
          "bandoneon" => "Bandoneonist",
          "violin" => "Violinist",
          "singer" => "Vocalist",
          "soloist" => "Soloist",
          "cello" => "Cellist",
          "viola" => "Violist"
        }.freeze

        def initialize(orchestra_name:, el_recodo_song:)
          @orchestra_name = orchestra_name
          @el_recodo_song = el_recodo_song
        end

        def build
          orchestra = Orchestra.new(name: @orchestra_name)
          orchestra.musicians = build_musicians
          attach_image(orchestra)
          orchestra.save!
          orchestra
        end

        private

        def build_musicians
          return [] unless @el_recodo_song

          @el_recodo_song.person_roles.filter_map do |person_role|
            role_key = person_role.role.downcase
            next if EXCLUDE_ROLES.include?(role_key)

            role = ROLE_TRANSLATION[role_key]
            raise UnrecognizedRoleError, "Unrecognized role: #{person_role.role}" unless role

            person = Person.find_or_create_by!(name: person_role.person.name)
            Musician.new(person:, role:)
          end
        end

        def attach_image(orchestra)
          return unless @el_recodo_song&.orchestra&.image&.attached?

          orchestra.image.attach(@el_recodo_song.orchestra.image.blob)
        end
      end
    end
  end
end
