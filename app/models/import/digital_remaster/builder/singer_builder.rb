module Import
  module DigitalRemaster
    module Builder
      class SongBuilder
        def initialize(metadata)
          @metadata = metadata
        end

        def build
          song = Song.new(
            title: @metadata.title,
            composer: build_composer,
            lyricist: build_lyricist,
            duration: @metadata.duration
          )
          song.save!
          song
        end

        private

        def build_composer
          return if @metadata.composer.blank?

          Person.find_or_create_by!(name: @metadata.composer)
        end

        def build_lyricist
          return if @metadata.lyricist.blank?

          Person.find_or_create_by!(name: @metadata.lyricist)
        end
      end
    end
  end
end
