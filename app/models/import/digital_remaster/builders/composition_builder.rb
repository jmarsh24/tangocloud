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
          composition = find_or_create_composition

          if @composer_name.present?
            composer_person = Person.find_or_create_by!(name: @composer_name)
            composition.composition_roles.find_or_create_by!(person: composer_person, role: "composer")
          end

          if @lyricist_name.present?
            lyricist_person = Person.find_or_create_by!(name: @lyricist_name)
            composition.composition_roles.find_or_create_by!(person: lyricist_person, role: "lyricist")
          end

          if @lyrics.present?
            language = Language.find_or_create_by!(name: "spanish", code: "es")
            existing_lyric = composition.lyrics.find_by(text: @lyrics, language:)

            unless existing_lyric
              lyric = Lyric.create!(text: @lyrics, language:)
              composition.lyrics << lyric
            end
          end

          composition
        end

        private

        def find_or_create_composition
          if @composer_name.present?
            composer_person = Person.find_or_create_by!(name: @composer_name)
            existing_composition = Composition.joins(:composition_roles)
              .where(title: @title, composition_roles: {person: composer_person, role: "composer"})
              .first

            return existing_composition if existing_composition
          end

          if @lyricist_name.present?
            lyricist_person = Person.find_or_create_by!(name: @lyricist_name)
            existing_composition = Composition.joins(:composition_roles)
              .where(title: @title, composition_roles: {person: lyricist_person, role: "lyricist"})
              .first

            return existing_composition if existing_composition
          end

          Composition.find_or_create_by!(title: @title)
        end
      end
    end
  end
end
