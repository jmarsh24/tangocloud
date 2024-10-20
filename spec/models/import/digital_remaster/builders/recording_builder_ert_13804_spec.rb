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
    context "when building a new recording with title metadata" do
      it "creates a new recording with the correct title" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.title).to eq("Ciego")
      end
    end

    context "when building a new recording with artist metadata" do
      it "creates a new recording with the correct artist" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        singer_names = recording.recording_singers.map { _1.person.name }
        expect(singer_names).to include("Armando Cupo")
      end
    end

    context "when building a new recording with composer metadata" do
      it "creates a new recording with the correct composer" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.composers.first.name).to eq("Luis Rubistein")
      end
    end

    context "when building a new recording with lyricist metadata" do
      it "creates a new recording with the correct lyricist" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.lyricists.first.name).to eq("Luis Rubistein")
      end
    end

    context "when building a new recording with genre metadata" do
      it "creates a new recording with the correct genre" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.genre.name).to eq("Tango")
      end
    end

    context "when building a new recording with album artist metadata" do
      it "creates a new recording with the correct album artist" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.orchestra.name).to eq("Alberto Moran")
      end
    end

    context "when building a new recording with year metadata" do
      it "creates a new recording with the correct year" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.recorded_date.year).to eq(1955)
      end
    end

    context "when building a new recording with barcode metadata" do
      it "creates a new recording with the correct barcode" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.el_recodo_song.ert_number).to eq(13804)
      end
    end

    context "when building a new recording with date metadata" do
      it "creates a new recording with the correct date" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.recorded_date).to eq("1955-01-01".to_date)
      end
    end

    context "when building a new recording with organization metadata" do
      it "creates a new recording with the correct organization" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.record_label.name).to eq("tango records")
      end
    end

    context "when building a new recording with lyrics metadata" do
      it "creates a new recording with the correct lyrics" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.lyrics.first.text).to eq("Letra de la canción")
      end
    end

    context "when creating a new recording without duplicates" do
      it "does not create duplicate compositions" do
        existing_composition = Composition.create!(title: "Ciego")
        person = Person.create!(name: "Luis Rubistein")
        existing_composition.composers << person
        builder = described_class.new(recording_metadata:)

        recording = builder.build

        expect(recording.composition.id).to eq(existing_composition.id)
      end

      it "does not create duplicate genres" do
        existing_genre = Genre.find_or_create_by(name: "Tango")
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.genre.id).to eq(existing_genre.id)
      end

      it "does not create duplicate record labels" do
        existing_record_label = RecordLabel.create!(name: "tango records")
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.record_label.id).to eq(existing_record_label.id)
      end
    end

    context "when handling unrecognized roles" do
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
