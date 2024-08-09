require "rails_helper"

RSpec.describe Import::DigitalRemaster::Builders::RecordingBuilder do
  let(:recording_metadata) do
    Import::DigitalRemaster::Builder::RecordingMetadata.new(
      date: "1953-01-01",
      title: "Vuelve la serenata",
      genre: "Vals",
      artist: "Jorge Casal, Raúl Berón",
      composer: "Aníbal Troilo",
      lyricist: "Cátulo Castillo",
      album_artist: "Aníbal Troilo",
      album_artist_sort: "Troilo, Aníbal",
      year: "1953",
      grouping: "Free",
      catalog_number: "TC7514",
      barcode: "ERT-2918",
      organization: nil,
      lyrics: "Letra de la canción"
    )
  end

  describe "#build" do
    context "when building a new recording with nil organization and el_recodo_song" do
      it "creates a new recording without el_recodo_song and organization" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording).to be_a(Recording)
        expect(recording).to be_persisted
      end
    end
  end
end
