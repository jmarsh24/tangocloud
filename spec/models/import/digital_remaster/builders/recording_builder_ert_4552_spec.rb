require "rails_helper"

RSpec.describe Import::DigitalRemaster::Builders::RecordingBuilder do
  let(:recording_metadata) do
    Import::DigitalRemaster::Builder::RecordingMetadata.new(
      date: "1939-02-01",
      title: "Te quiero ver escopeta",
      genre: "Tango",
      artist: "Roberto Flores",
      composer: "Enrique Rodríguez",
      lyricist: "Alfredo Bigeschi",
      album_artist: "Enrique Rodríguez",
      album_artist_sort: "Rodríguez, Enrique",
      year: "1939",
      grouping: "Tango Tunes",
      catalog_number: "TC6612",
      barcode: "ERT-4552",
      organization: nil,
      lyrics: "Letra de la canción"
    )
  end

  let(:el_recodo_song) {
    build(:external_catalog_el_recodo_song,
      title: "Te quiero ver escopeta",
      ert_number: 4552,
      label: "Odeon")
  }

  let(:el_recodo_orchestra) {
    ExternalCatalog::ElRecodo::Orchestra.create!(
      name: "Enrique Rodríguez",
      song: el_recodo_song
    )
  }

  let(:el_recodo_person) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Roberto Flores",
      birth_date: "1907-07-29",
      death_date: "1981-11-09",
      place_of_birth: "Buenos Aires Argentina"
    )
  }

  let(:el_recodo_person2) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Enrique Rodríguez",
      birth_date: "1901-03-08",
      death_date: "1982-06-28",
      place_of_birth: "Zárate (Buenos Aires) Argentina"
    )
  }

  let(:el_recodo_person3) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Alfredo Bigeschi",
      birth_date: "1914-07-11",
      death_date: "1975-05-18",
      nicknames: ["Pichuco"],
      place_of_birth: "Buenos Aires Argentina"
    )
  }

  let(:el_recodo_person_roles) {
    [
      ExternalCatalog::ElRecodo::PersonRole.create!(
        role: "singer",
        song: el_recodo_song,
        person: el_recodo_person
      ),
      ExternalCatalog::ElRecodo::PersonRole.create!(
        role: "composer",
        song: el_recodo_song,
        person: el_recodo_person2
      ),
      ExternalCatalog::ElRecodo::PersonRole.create!(
        role: "author",
        song: el_recodo_song,
        person: el_recodo_person3
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

        expect(recording.composition.title).to eq("Te quiero ver escopeta")
      end
    end

    context "when building a new recording with artist metadata" do
      it "creates a new recording with the correct artist" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        singer_names = recording.recording_singers.map { |singer| singer.person.name }
        expect(singer_names).to include("Roberto Flores")
      end
    end

    context "when building a new recording with composer metadata" do
      it "creates a new recording with the correct composer" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.composers.first.name).to eq("Enrique Rodríguez")
      end
    end

    context "when building a new recording with lyricist metadata" do
      it "creates a new recording with the correct lyricist" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.lyricists.first.name).to eq("Alfredo Bigeschi")
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

        expect(recording.orchestra.name).to eq("Enrique Rodríguez")
      end
    end

    context "when building a new recording with year metadata" do
      it "creates a new recording with the correct year" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.recorded_date.year).to eq(1939)
      end
    end

    context "when building a new recording with barcode metadata" do
      it "creates a new recording with the correct barcode" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.el_recodo_song.ert_number).to eq(4552)
      end
    end

    context "when building a new recording with date metadata" do
      it "creates a new recording with the correct date" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.recorded_date).to eq("1939-02-01".to_date)
      end
    end

    context "when creating a new recording without duplicates" do
      it "does not create duplicate compositions" do
        existing_composition = Composition.create!(title: "Te quiero ver escopeta")
        composer_person = Person.create!(name: "Enrique Rodríguez")
        existing_composition.composers << composer_person
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
        existing_record_label = RecordLabel.create!(name: "odeon")
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
