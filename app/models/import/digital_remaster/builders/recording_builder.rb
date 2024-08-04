module Import
  module DigitalRemaster
    module Builders
      class RecordingBuilder
        def initialize(recording_metadata:)
          @metadata = recording_metadata
        end

        def build
          el_recodo_song = find_el_recodo_song

          recording = Recording.new(
            el_recodo_song:,
            composition: build_composition,
            recorded_date: @metadata.date,
            orchestra: build_orchestra(el_recodo_song),
            genre: build_genre,
            time_period: find_existing_time_period,
            record_label: build_record_label
          )

          singers = SingerBuilder.new(name: @metadata.artist).build

          singers.each do
            recording.recording_singers.build(person: _1.person, soloist: _1.soloist)
          end

          recording.save!
          recording
        end

        private

        def find_el_recodo_song
          return if @metadata.barcode.blank?

          ert_number = @metadata.barcode.split("-")[1]
          ExternalCatalog::ElRecodo::Song.includes(:people, :person_roles).find_by(ert_number:)
        end

        def build_orchestra(el_recodo_song)
          OrchestraBuilder.new(orchestra_name: @metadata.album_artist, el_recodo_song:).build
        end

        def build_composition
          CompositionBuilder.new(
            composer_name: @metadata.composer,
            lyricist_name: @metadata.lyricist,
            title: @metadata.title,
            lyrics: @metadata.lyrics
          ).build
        end

        def find_existing_time_period
          return nil if @metadata.date.blank?

          year = Date.parse(@metadata.date).year
          TimePeriod.covering_year(year).first
        end

        def build_record_label
          return if @metadata.organization.blank?

          RecordLabel.find_or_create_by!(name: @metadata.organization)
        end

        def build_genre
          return if @metadata.genre.blank?

          Genre.find_or_create_by!(name: @metadata.genre)
        end
      end
    end
  end
end
