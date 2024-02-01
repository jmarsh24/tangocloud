# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::Music::SongImporter do
  let(:tangotunes_file) { Rails.root.join("spec", "fixtures", "audio", "19401008_volver_a_sonar_roberto_rufino_tango_2476.flac") }
  let(:tangotimetravel_file) { Rails.root.join("spec", "fixtures", "audio", "19380307_comme_il_faut_instrumental_tango_2758.aif") }

  describe "#import" do
    context "when song is from tangotunes" do
      fit "imports the song" do
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

        audio_transfer = described_class.new(file: tangotunes_file).import
        expect(audio_transfer).to be_persisted
      end
    end

    context "when song is from tangotimetravel" do
      it "imports the song" do
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

        audio_transfer = described_class.new(file: tangotimetravel_file).import
        expect(audio_transfer).to be_persisted
      end
    end
  end
end
