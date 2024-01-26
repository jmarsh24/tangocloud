# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::Music::SongImporter do
  let(:tangotunes_file) { Rails.root.join("spec", "fixtures", "Amarras 79782-1_RP.flac") }
  let(:tangotimetravel_file) { Rails.root.join("spec", "fixtures", "029_-_Nunca_tuvo_novio.aif") }

  describe "#import" do
    context "when song is from tangotunes" do
      it "imports the song" do
        ElRecodoSong.create!(
          date: Date.new(1944, 7, 21),
          ert_number: 4035,
          music_id: 4035,
          title: "Amarras",
          style: "TANGO",
          orchestra: "Juan D'ARIENZO",
          singer: "Héctor Mauré",
          composer: "Carlos Marchisio",
          author: "Carmelo Santiago",
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
          date: Date.new(1943, 4, 16),
          ert_number: 4337,
          music_id: 4337,
          title: "Nunca tuvo novio",
          style: "TANGO",
          orchestra: "Pedro LAURENZ",
          singer: "Alberto Podestá",
          composer: "Agustín Bardi",
          author: "Enrique Cadícamo",
          label: "RCA Victor",
          page_updated_at: Date.new(2023, 6, 18)
        )

        audio_transfer = described_class.new(file: tangotimetravel_file).import
        expect(audio_transfer).to be_persisted
      end
    end
  end
end
