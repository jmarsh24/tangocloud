module Import
  module DigitalRemaster
    module Builders
      class OrchestraBuilder
        def initialize(metadata:, el_recodo_song:)
          @metadata = metadata
          @el_recodo_song = el_recodo_song
        end

        def build
          orchestra = Orchestra.new(
            name: @metadata.orchestra_name,
            conductor: build_conductor,
            musicians: build_musicians
          )
          orchestra.save!
          orchestra
        end

        private

        def build_conductor
          return if @metadata.conductor.blank?

          Person.find_or_create_by!(name: @metadata.conductor)
        end

        def build_musicians
          musicians = []
          if @el_recodo_song.present?
            @el_recodo_song.people.each do |person|
              musicians << Musician.new(person:, role: ROLE_TRANSLATION[person.role])
            end
          end

          unless @metadata.musicians.blank?
            @metadata.musicians.split(",").map(&:strip).each do |musician_name|
              person = Person.find_or_create_by!(name: musician_name)
              musicians << Musician.new(person:, role: ROLE_TRANSLATION[musician_name.role])
            end
          end

          musicians
        end
      end
    end
  end
end
