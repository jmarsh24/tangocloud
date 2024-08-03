module Import
  module DigitalRemaster
    module Builders
      class CompositionBuilder
        def initialize(composer_name:, lyricist_name:, title:, lyrics:)
          @composer_name = composer_name
          @lyricist_name = lyricist_name
          @title = title
          @lyrics = lyrics
        end

        def build
          composition = Composition.find_or_create_by!(title: @title)

          if @composer_name.present?
            composer_person = Person.find_or_create_by!(name: @composer_name)
            composition.composition_roles.find_or_create_by!(composition:, person: composer_person, role: "composer")
          end

          if @lyricist_name.present?
            lyricist_person = Person.find_or_create_by!(name: @lyricist_name)
            composition.composition_roles.find_or_create_by!(composition:, person: lyricist_person, role: "lyricist")
          end

          build_lyric(composition)

          composition
        end

        private

        def build_lyric(composition)
          return if @lyrics.blank?

          language = Language.find_or_create_by!(name: "spanish", code: "es")
          lyric = Lyric.create!(text: @lyrics, language:)
          composition.lyrics << lyric
        end
      end
    end
  end
end
