module Import
  module DigitalRemaster
    module Builders
      class CompositionBuilder
        def initialize(metadata)
          @metadata = metadata
        end

        def build
          composition = Composition.find_or_create_by!(title: @metadata.title)

          if @metadata.composer.present?
            composer_person = Person.find_or_create_by!(name: @metadata.composer)
            composition.composition_roles.find_or_create_by!(composition:, person: composer_person,
              role: “composer”)
          end

          if @metadata.lyricist.present?
            lyricist_person = Person.find_or_create_by!(name: @metadata.lyricist)
            composition.composition_roles.find_or_create_by!(composition:, person: lyricist_person, role: "lyricist")
          end

          build_lyric(composition)

          composition
        end

        def build_lyric(composition)
          return if @metadata.lyrics.blank?

          language = Language.find_or_create_by!(name: "spanish", code: "es")
          lyric = Lyric.create!(text: @metadata.lyrics, language:)
          composition.lyrics << lyric
        end
      end
    end
  end
end
