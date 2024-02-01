require "rails_helper"

RSpec.describe Import::Music::SongImporter do
  let(:flac_file) { Rails.root.join("spec", "fixtures", "audio", "19401008_volver_a_sonar_roberto_rufino_tango_2476.flac") }
  let(:aif_file) { Rails.root.join("spec", "fixtures", "audio", "19380307_comme_il_faut_instrumental_tango_2758.aif") }

  describe "#import" do
    context "when song is from flac" do
      subject(:audio_transfer) { described_class.new(file: flac_file).import }

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
        audio_transfer
      end

      it "sucessfully creates an audio_transfer with the correct attributes" do
        expect(audio_transfer).to be_present
        expect(audio_transfer.external_id).to be_nil
      end

      it "creates a new audio with correct attributes" do
        audio = audio_transfer.audio
        expect(audio).to be_present
        expect(audio.format).to eq("aac")
        expect(audio.bit_rate).to eq(320)
        expect(audio.sample_rate).to eq(48000)
        expect(audio.channels).to eq(1)
        expect(audio.codec).to eq("aac_at")
        expect(audio.length).to eq(165)
        expect(audio.metadata).to be_present
      end

      it "creates a new composition" do
        composition = audio_transfer.recording.composition

        expect(composition.title).to eq("volver a sonar")
      end

      it "creates a new lyric" do
        lyric = audio_transfer.recording.composition.lyrics
        expect(lyric.locale).to eq("es")
      end

      it "creates a new orchestra" do
        orchestra = audio_transfer.recording.orchestra
        expect(orchestra.name).to eq("carlos di sarli")
      end

      it "creates a new record label" do
        record_label = audio_transfer.recording.record_label
        expect(record_label.name).to eq("rca victor")
      end

      it "creates a new genre" do
        genre = audio_transfer.recording.genre
        expect(genre.name).to eq("tango")
      end

      it "creates a new singer" do
        singer = audio_transfer.recording.singer
        expect(singer.name).to eq("roberto rufino")
      end

      it "creates a new lyricist" do
        lyricist = audio_transfer.recording.composition.lyricist
        expect(lyricist.name).to eq("francisco garcia jimenez")
      end

      it "creates a new composer" do
        composer = audio_transfer.recording.composition.composer
        expect(composer.name).to eq("andres fraga")
      end

      it "creates a new recording" do
        recording = audio_transfer.recording
        expect(recording.title).to eq("volver a sonar")
        expect(recording.bpm).to eq(130)
        expect(recording.recorded_date).to eq(Date.new(1940, 10, 8))
        expect(recording.release_date).to eq(Date.new(1940, 10, 8))
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
        described_class.new(file: aif_file).import
      end

      it "creates a new audio with correct attributes" do
        el_recodo_song = ElRecodoSong.find_by!(ert_number: 2758)
        expect(el_recodo_song.audio).to be_present
        expect(el_recodo_song.audio.bit_rate).to eq(1411)
        expect(el_recodo_song.audio.sample_rate).to eq(44100)
        expect(el_recodo_song.audio.channels).to eq(2)
        expect(el_recodo_song.audio.bit_depth).to eq(16)
        expect(el_recodo_song.audio.bit_rate_mode).to eq("CBR")
        expect(el_recodo_song.audio.codec).to eq("PCM S16 LE (s16l)")
        expect(el_recodo_song.audio.length).to eq(2.0)
        expect(el_recodo_song.audio.encoder).to eq("Lavf58.20.100")
      end

      it "creates a new audio transfer" do

      end

      it "creates a new composition" do

      end

      it "creates a new lyric" do

      end

      it "creates a new orchestra" do

      end

      it "creates a new record label" do

      end

      it "creates a new genre" do

      end

      it "creates a new singer" do

      end

      it "creates a new lyricist" do

      end

      it "creates a new composer" do

      end

      it "creates a new recording" do

      end
    end

    context "when an el recodo song does not exist" do
      it "raises an error" do

      end
    end

    context "when an el recodo song does not exist" do
      it "raises an error" do

      end
    end
  end
end
