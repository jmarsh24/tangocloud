require "rails_helper"

RSpec.describe Import::DigitalRemaster::Builders::RecordingBuilder do
  let(:recording_metadata) do
    Import::DigitalRemaster::Builder::RecordingMetadata.new(
      title: "Ciego",
      artist: "Dir. Armando Cupo",
      composer: "Luis Rubistein",
      lyricist: "Luis Rubistein",
      genre: "Tango",
      album_artist: "Alberto Moran",
      album_artist_sort: "Morán, Alberto",
      year: "1955",
      grouping: "Free",
      catalog_number: "TC5905",
      barcode: "ERT-13804",
      date: "1955-01-01",
      organization: "Tango Records",
      lyrics: "Letra de la canción"
    )
  end

  let(:el_recodo_song) {
    build(:external_catalog_el_recodo_song,
      title: "Ciego",
      ert_number: "13804")
  }

  let(:el_recodo_person) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Alberto Moran",
      birth_date: "1922-06-10",
      death_date: "1988-11-16",
      nicknames: ["El morocho del tango"],
      place_of_birth: "Buenos Aires"
    )
  }

  let(:el_recodo_person2) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Aníbal Troilo",
      birth_date: "1914-07-11",
      death_date: "1975-05-18",
      nicknames: ["Pichuco"],
      place_of_birth: "Buenos Aires"
    )
  }

  let(:el_recodo_person_roles) {
    [
      ExternalCatalog::ElRecodo::PersonRole.create!(
        role: "piano",
        song: el_recodo_song,
        person: el_recodo_person
      ),
      ExternalCatalog::ElRecodo::PersonRole.create!(
        role: "bandoneon",
        song: el_recodo_song,
        person: el_recodo_person2
      )
    ]
  }

  before do
    el_recodo_person_roles
  end

  describe "#build" do
    context "when building a new recording" do
      it "creates a new recording with all attributes" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.recorded_date).to eq("1955-01-01".to_date)
        expect(recording.composition.title).to eq("Ciego")
        expect(recording.composition.composers.first.name).to eq("Luis Rubistein")
        expect(recording.composition.lyricists.first.name).to eq("Luis Rubistein")
        expect(recording.composition.lyrics.first.text).to eq("Letra de la canción")
        expect(recording.genre.name).to eq("Tango")
        expect(recording.record_label.name).to eq("Tango Records")
      end

      it "creates a new recording with associated orchestra" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.orchestra.name).to eq("Alberto Moran")
      end

      it "creates a new recording with associated singers" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        singer_names = recording.recording_singers.map { _1.person.name }
        expect(singer_names).to include("Armando Cupo")
        expect(recording.recording_singers.find { _1.person.name == "Armando Cupo" }.soloist).to be_truthy
      end

      it "does not create duplicate compositions" do
        existing_composition = Composition.create!(title: "Ciego")
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.id).to eq(existing_composition.id)
      end

      it "does not create duplicate genres" do
        existing_genre = Genre.create!(name: "Tango")
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.genre.id).to eq(existing_genre.id)
      end

      it "does not create duplicate record labels" do
        existing_record_label = RecordLabel.create!(name: "Tango Records")
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.record_label.id).to eq(existing_record_label.id)
      end

      it "raises an error for unrecognized roles" do
        el_recodo_person_roles.first.update!(role: "unknown")

        builder = described_class.new(recording_metadata:)

        expect { builder.build }.to raise_error(Import::DigitalRemaster::Builders::OrchestraBuilder::UnrecognizedRoleError)
      end

      it "excludes roles defined in EXCLUDE_ROLES" do
        el_recodo_person_roles.first.update!(role: "arranger")

        builder = described_class.new(recording_metadata:)
        recording = builder.build

        position = OrchestraPosition.find_by(
          orchestra: recording.orchestra,
          person: el_recodo_person
        )

        expect(position).to be_nil
      end
    end
  end
end