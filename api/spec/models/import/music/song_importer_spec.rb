require "rails_helper"

RSpec.describe Import::Music::SongImporter do
  let(:flac_file) { Rails.root.join("spec", "fixtures", "audio", "19401008_volver_a_sonar_roberto_rufino_tango_2476.flac") }
  let(:aif_file) { Rails.root.join("spec", "fixtures", "audio", "19380307_comme_il_faut_instrumental_tango_2758.aif") }

  describe "#import" do
    context "when song is from flac" do
      before do
        ElRecodoSong.create!(
          date: Date.new(1940, 10, 8),
          ert_number: 2476,
          music_id: 2476,
          title: "Volver a soñar",
          style: "TANGO",
          orchestra: "Carlos DI SARLI",
          singer: "Roberto Rufino",
          composer: "Andrés Fraga",
          label: "RCA Victor",
          page_updated_at: Date.new(2013, 7, 10)
        )
        AudioTransfer.find_by(filename: File.basename(flac_file)).destroy!
      end

      it "sucessfully creates an audio_transfer with the correct attributes" do
        audio_transfer = described_class.new(file: flac_file).import
        expect(audio_transfer).to be_present
        expect(audio_transfer.external_id).to be_nil
        # creates a reference to the el recodo song
        expect(audio_transfer.recording.el_recodo_song).to be_present
        expect(audio_transfer.recording.el_recodo_song.title).to eq("Volver a soñar")
        # creates a new audio with correct attributes
        audio = audio_transfer.audio_variants.first
        expect(audio).to be_present
        expect(audio.format).to eq("aac")
        expect(audio.bit_rate).to eq(320)
        expect(audio.sample_rate).to eq(48000)
        expect(audio.channels).to eq(1)
        expect(audio.codec).to eq("aac_at")
        expect(audio.duration).to eq(165)
        expect(audio.metadata).to be_present
        # creates a new composition
        composition = audio_transfer.recording.composition
        expect(composition.title).to eq("volver a sonar")
        # creates a new lyric
        lyric = audio_transfer.recording.composition.lyrics.where(locale: "es").first
        expect(lyric.content).to be_present
        # creates a new orchestra
        orchestra = audio_transfer.recording.orchestra
        expect(orchestra.name).to eq("carlos di sarli")
        # creates a new album
        album = audio_transfer.album
        expect(album.title).to eq("tt - todo de carlos -1939-1941 [flac]")
        # creates a new album_art
        expect(album.album_art).to be_attached
        # creates a new record label
        record_label = audio_transfer.recording.record_label
        expect(record_label.name).to eq("rca victor")
        # creates a new genre
        genre = audio_transfer.recording.genre
        expect(genre.name).to eq("tango")
        # creates a new singer
        singer = audio_transfer.recording.singers.first
        expect(singer.name).to eq("roberto rufino")
        # creates a new lyricist
        lyricist = audio_transfer.recording.composition.lyricist
        expect(lyricist.name).to eq("francisco garcia jimenez")
        # creates a new composer
        composer = audio_transfer.recording.composition.composer
        expect(composer.name).to eq("andres fraga")
        # creates a new recording
        recording = audio_transfer.recording
        # attaches source audio to audio_transfer
        expect(audio_transfer.source_audio).to be_attached
        # creates a waveform for the audio_transfer
        expect(audio_transfer.waveform).to be_present
        expect(audio_transfer.waveform.data).to be_present

        expect(recording.title).to eq("volver a sonar")
        expect(recording.bpm).to eq(130)
        expect(recording.recorded_date).to eq(Date.new(1940, 10, 8))
        expect(recording.release_date).to eq(Date.new(1940, 10, 8))
        expect {
          described_class.new(file: flac_file).import
        }.to raise_error(Import::Music::SongImporter::DuplicateFileError)
      end
    end

    context "when song is from aif" do
      before do
        ElRecodoSong.create!(
          date: Date.new(1938, 3, 7),
          ert_number: 2758,
          music_id: 2758,
          title: "Comme il faut",
          style: "TANGO",
          orchestra: "Aníbal TROILO",
          singer: "Instrumental",
          composer: "Eduardo Arolas",
          author: "Gabriel Clausi",
          label: "Odeon",
          page_updated_at: Date.new(2013, 7, 10)
        )
      end

      it "creates a new audio with correct attributes" do
        audio_transfer = described_class.new(file: aif_file).import
        audio_variant = audio_transfer.audio_variants.first
        expect(audio_variant).to be_present
        expect(audio_variant.format).to eq("aac")
        expect(audio_variant.bit_rate).to eq(320)
        expect(audio_variant.sample_rate).to eq(48000)
        expect(audio_variant.channels).to eq(1)
        expect(audio_variant.codec).to eq("aac_at")
        expect(audio_variant.duration).to eq(163)
        expect(audio_variant.metadata).to be_present
        #  creates a new audio transfer
        expect(audio_transfer).to be_present
        expect(audio_transfer.external_id).to be_nil
        #  creates a reference to the el recodo song
        expect(audio_transfer.recording.el_recodo_song).to be_present
        expect(audio_transfer.recording.el_recodo_song.title).to eq("Comme il faut")
        #  creates a new composition
        expect(audio_transfer.recording.composition.title).to eq("comme il faut")
        #  creates a new lyric
        lyric = audio_transfer.recording.composition.lyrics.where(locale: "es").first
        expect(lyric).to be_present
        # creates a new album
        expect(audio_transfer.album.title).to eq("tt - todo de anibal, 1938-1942 [aiff]")
        #  creates a new album_art
        expect(audio_transfer.album.album_art).to be_attached
        #  creates a new orchestra
        expect(audio_transfer.recording.orchestra.name).to eq("anibal troilo")
        #  creates a new record label
        expect(audio_transfer.recording.record_label.name).to eq("odeon")
        #  creates a new genre
        expect(audio_transfer.recording.genre.name).to eq("tango")
        #  creates a new singer
        expect(audio_transfer.recording.singers).to eq([])
        #  creates a new lyricist
        expect(audio_transfer.recording.composition.lyricist.name).to eq("gabriel clausi")
        #  creates a new composer
        expect(audio_transfer.recording.composition.composer.name).to eq("eduardo arolas")
        # creates a waveform for the audio_transfer
        expect(audio_transfer.waveform).to be_present
        expect(audio_transfer.waveform.data).to be_present
        expect(audio_transfer.source_audio).to be_attached
        #  creates a new recording
        expect(audio_transfer.recording.title).to eq("comme il faut")
        # attaches source audio to audio_transfer
        expect {
          described_class.new(file: aif_file).import
        }.to raise_error(Import::Music::SongImporter::DuplicateFileError)
      end
    end
  end
end
