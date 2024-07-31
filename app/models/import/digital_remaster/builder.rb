module Import
  module DigitalRemaster
    class Builder
      ROLE_TRANSLATION = {
        "piano" => "Pianist",
        "arranger" => "Arranger",
        "doublebass" => "Double Bassist",
        "bandoneon" => "Bandoneonist",
        "violin" => "Violinist",
        "singer" => "Vocalist",
        "soloist" => "Soloist",
        "director" => "Conductor",
        "composer" => "Composer",
        "author" => "Lyricist",
        "cello" => "Cellist"
      }.freeze

      def initialize
        @digital_remaster = ::DigitalRemaster.new
      end

      def extract_metadata(file:)
        AudioProcessing::MetadataExtractor.new(file:).extract
      end

      def generate_waveform_image(file:)
        AudioProcessing::WaveformGenerator.new(file:).generate_image
      end

      def generate_waveform(file:)
        AudioProcessing::WaveformGenerator.new(file:).generate
      end

      def extract_album_art(file:)
        AudioProcessing::AlbumArtExtractor.new(file:).extract
      end

      def compress_audio(file:)
        AudioProcessing::AudioConverter.new(file:).convert
      end

      def build_audio_variant(metadata:)
        return if metadata.format.blank?

        AudioVariant.new(
          format: metadata.format,
          bit_rate: metadata.bit_rate
        )
      end

      def build_waveform(waveform:)
        return if waveform.blank?

        Waveform.new(
          version: waveform.version,
          channels: waveform.channels,
          sample_rate: waveform.sample_rate,
          samples_per_pixel: waveform.samples_per_pixel,
          bits: waveform.bits,
          length: waveform.length,
          data: waveform.data
        )
      end

      def build_recording(metadata:)
        el_recodo_song = find_el_recodo_song(metadata:)

        Recording.new(
          el_recodo_song:,
          composition: find_or_initialize_composition(metadata:),
          recorded_date: metadata.date,
          orchestra: find_or_initialize_orchestra(metadata:, el_recodo_song:),
          genre: find_or_initialize_genre(metadata:),
          singers: find_or_initialize_singers(metadata:),
          time_period: find_existing_time_period(metadata:),
          record_label: find_or_initialize_record_label(metadata:)
        )
      end

      def find_el_recodo_song(metadata:)
        return if metadata.barcode.blank?

        ert_number = metadata.barcode.split("-")[1]
        ExternalCatalog::ElRecodo::Song.includes(:people, :person_roles).find_by(ert_number:)
      end

      def find_or_initialize_album(metadata:)
        return if metadata.album.blank?

        Album.find_or_initialize_by(title: metadata.album)
      end

      def find_or_initialize_remaster_agent(metadata:)
        return if metadata.organization.blank?

        RemasterAgent.find_or_initialize_by(name: metadata.organization)
      end

      def find_or_initialize_orchestra(metadata:, el_recodo_song: nil)
        return if metadata.album_artist.blank?

        orchestra = Orchestra.find_or_initialize_by(name: metadata.album_artist) do |orchestra|
          orchestra.sort_name = metadata.album_artist_sort
        end

        if el_recodo_song && orchestra.image.blank? && el_recodo_song.orchestra&.image&.attached?
          orchestra.image.attach(el_recodo_song.orchestra.image.blob)
        end

        return orchestra if el_recodo_song.blank?

        roles_to_include = ["piano", "doublebass", "violin", "viola", "cello"]
        el_recodo_song.person_roles.each do |person_role|
          next unless roles_to_include.include?(person_role.role.downcase)

          person = Person.find_or_initialize_by(
            name: person_role.person.name,
            birth_date: person_role.person.birth_date,
            death_date: person_role.person.death_date,
            el_recodo_person: person_role.person,
            nickname: person_role.person.nicknames.first,
            birth_place: person_role.person.place_of_birth
          )

          if person.image.blank? && person_role.person&.image&.attached?
            person.image.attach(person_role.person.image.blob)
          end

          orchestra_role = OrchestraRole.find_or_initialize_by(name: ROLE_TRANSLATION[person_role.role])
          orchestra.orchestra_positions.build(
            person:,
            orchestra_role:
          )
        end

        orchestra
      end

      def find_or_initialize_singers(metadata:)
        return if metadata.artist.blank?

        metadata.artist.split(",").map(&:strip).filter_map do |singer_name|
          next if singer_name.casecmp("instrumental").zero?

          singer_name = singer_name.sub("Dir. ", "").strip if singer_name.start_with?("Dir. ")
          Person.find_or_initialize_by(name: singer_name)
        end
      end

      def find_or_initialize_genre(metadata:)
        return if metadata.genre.blank?

        Genre.find_or_initialize_by(name: metadata.genre)
      end

      def find_or_initialize_composer(metadata:)
        return if metadata.composer.blank?

        Person.find_or_initialize_by(name: metadata.composer)
      end

      def find_or_initialize_lyricist(metadata:)
        return if metadata.lyricist.blank?

        Person.find_or_initialize_by(name: metadata.lyricist)
      end

      def find_or_initialize_composition(metadata:)
        composition = Composition.find_or_initialize_by(title: metadata.title) do |comp|
          comp.composers << find_or_initialize_composer(metadata:) if metadata.composer.present?
          comp.lyricists << find_or_initialize_lyricist(metadata:) if metadata.lyricist.present?
        end
        find_or_initialize_lyrics(metadata:, composition:)

        composition
      end

      def find_or_initialize_lyrics(metadata:, composition:)
        return if metadata.lyrics.blank?

        composition.lyrics.find_or_initialize_by(text: metadata.lyrics) do |lyric|
          lyric.language = Language.find_or_initialize_by(name: "spanish", code: "es")
          lyric.composition = composition
        end
      end

      def find_existing_time_period(metadata:)
        return nil if metadata.date.blank?

        year = Date.parse(metadata.date).year
        TimePeriod.covering_year(year).first
      end

      def find_or_initialize_record_label(metadata:)
        return if metadata.organization.blank?

        RecordLabel.find_or_initialize_by(name: metadata.organization)
      end

      def build_digital_remaster(audio_file:, metadata:, waveform:, waveform_image:, album_art:, compressed_audio:)
        album = find_or_initialize_album(metadata:)
        remaster_agent = find_or_initialize_remaster_agent(metadata:)
        find_or_initialize_composition(metadata:)
        recording = build_recording(metadata:)
        audio_variant = build_audio_variant(metadata:)
        waveform = build_waveform(waveform:)
        @digital_remaster.duration = metadata.duration
        @digital_remaster.replay_gain = metadata.replaygain_track_gain.to_f
        @digital_remaster.peak_value = metadata.replaygain_track_peak.to_f
        @digital_remaster.tango_cloud_id = metadata.catalog_number&.split("TC")&.last.to_i
        @digital_remaster.album = album
        @digital_remaster.remaster_agent = remaster_agent
        @digital_remaster.recording = recording
        @digital_remaster.waveform = waveform
        @digital_remaster.audio_file = audio_file

        @digital_remaster.audio_variants << audio_variant

        album.album_art.attach(io: File.open(album_art), filename: File.basename(album_art))
        audio_variant.audio_file.attach(io: File.open(compressed_audio), filename: File.basename(compressed_audio))
        waveform.image.attach(io: File.open(waveform_image), filename: File.basename(waveform_image))

        @digital_remaster
      end
    end
  end
end
