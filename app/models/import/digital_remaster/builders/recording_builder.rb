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
            recorded_date: @date,
            orchestra: OrchestraBuilder.new(orchestra_name: @orchestra_name, conductor: @conductor, musicians: @musicians, el_recodo_song:).build,
            genre: build_genre,
            time_period: find_existing_time_period,
            record_label: build_record_label
          )

          singers = SingerBuilder.new(artist: @artist).build
          singers.each { |singer| recording.recording_singers.build(person: singer.person, soloist: singer.soloist) }

          recording.save!
          recording
        end

        private

        def find_el_recodo_song
          return if @barcode.blank?

          ert_number = @barcode.split("-")[1]
          ExternalCatalog::ElRecodo::Song.includes(:people, :person_roles).find_by(ert_number:)
        end

        def build_composition
          CompositionBuilder.new(title: @title, composer: @composer, lyricist: @lyricist).build
        end

        def find_existing_time_period
          return nil if @date.blank?

          year = Date.parse(@date).year
          TimePeriod.covering_year(year).first
        end

        def build_record_label
          return if @organization.blank?

          RecordLabel.find_or_create_by!(name: @organization)
        end

        def build_genre
          return if @genre.blank?

          Genre.find_or_create_by!(name: @genre)
        end
      end
    end
  end
end
