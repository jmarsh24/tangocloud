module Import
  module DigitalRemaster
    module Builders
      class CompositionBuilder
        def initialize(composer_names:, lyricist_names:, title:, lyrics:)
          @composer_names = composer_names || []
          @lyricist_names = lyricist_names || []
          @title = title
          @lyrics = lyrics
        end

        def build
          composition = find_or_create_composition

          @composer_names.each do |composer_name|
            composer_person = find_or_create_person_with_image(composer_name)
            composition.composition_roles.find_or_create_by!(person: composer_person, role: "composer")
          end

          @lyricist_names.each do |lyricist_name|
            lyricist_person = find_or_create_person_with_image(lyricist_name)
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
          composition = Composition.joins(:composition_roles)
            .where(title: @title)
            .where(composition_roles: {person_id: Person.where(name: @composer_names + @lyricist_names).select(:id)})
            .first

          composition || Composition.find_or_create_by!(title: @title)
        end

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
