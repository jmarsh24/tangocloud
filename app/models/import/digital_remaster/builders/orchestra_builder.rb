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
          orchestra = Orchestra.find_or_initialize_by(name: @orchestra_name)
          attach_image(orchestra)

          if @el_recodo_song.present?
            @el_recodo_song.person_roles.each do |person_role|
              role = person_role.role.downcase

              next if EXCLUDE_ROLES.include?(role)

              role_name = ROLE_TRANSLATION[role]
              raise UnrecognizedRoleError, "Unrecognized role: #{person_role.role}" unless role_name

              person = Person.find_or_create_by!(name: person_role.person.name)
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

        def attach_image(orchestra)
          return unless @el_recodo_song&.orchestra&.image&.attached?

          orchestra.image.attach(@el_recodo_song.orchestra.image.blob)
        end
      end
    end
  end
end