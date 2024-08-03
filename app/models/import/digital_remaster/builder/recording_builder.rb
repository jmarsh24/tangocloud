module Import
  module DigitalRemaster
    module Builder
      class RecordingBuilder
        def initialize(metadata)
          @metadata = metadata
        end

        def build
          el_recodo_song = find_el_recodo_song
          recording = Recording.new(
            el_recodo_song:,
            composition: build_composition,
            recorded_date: @metadata.date,
            orchestra: OrchestraBuilder.new(@metadata, el_recodo_song).build,
            genre: build_genre,
            time_period: find_existing_time_period,
            record_label: build_record_label
          )

          build_singers(recording) unless @metadata.artist.blank?
          recording.save!
          recording
        end

        private

        def find_el_recodo_song
          return if @metadata.barcode.blank?

          ert_number = @metadata.barcode.split("-")[1]
          ExternalCatalog::ElRecodo::Song.includes(:people, :person_roles).find_by(ert_number:)
        end

        def build_composition
          CompositionBuilder.new(@metadata).build
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

        def build_singers(recording)
          @metadata.artist.split(",").map(&:strip).each do |singer_name|
            next if singer_name.casecmp("instrumental").zero?

            soloist = false
            if singer_name.start_with?("Dir. ")
              singer_name = singer_name.sub("Dir. ", "").strip
              soloist = true
            end

            person = Person.find_or_create_by(name: singer_name)
            recording.recording_singers.build(person:, soloist:)
          end
        end
      end
    end
  end
end
