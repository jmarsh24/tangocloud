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
      organization: "Tk",
      lyrics: "Letra de la canción"
    )
  end

  let(:el_recodo_song) {
    build(:external_catalog_el_recodo_song,
      title: "Vuelve la serenata",
      ert_number: 2918,
      label: "Tk",
      duration: 179)
  }

  let(:el_recodo_orchestra) {
    ExternalCatalog::ElRecodo::Orchestra.create!(
      name: "Aníbal Troilo",
      song: el_recodo_song
    )
  }

  let(:el_recodo_person) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Jorge Casal",
      birth_date: "1924-01-14",
      death_date: "1996-06-25",
      place_of_birth: "Buenos Aires Argentina"
    )
  }

  let(:el_recodo_person2) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Raúl Berón",
      birth_date: "1920-03-30",
      death_date: "1982-06-28",
      place_of_birth: "Zárate (Buenos Aires) Argentina"
    )
  }

  let(:el_recodo_person3) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Aníbal Troilo",
      birth_date: "1914-07-11",
      death_date: "1975-05-18",
      nicknames: ["Pichuco"],
      place_of_birth: "Buenos Aires Argentina"
    )
  }

  let(:el_recodo_person4) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Cátulo Castillo",
      birth_date: "1906-08-06",
      death_date: "1975-10-19",
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
        role: "singer",
        song: el_recodo_song,
        person: el_recodo_person2
      ),
      ExternalCatalog::ElRecodo::PersonRole.create!(
        role: "composer",
        song: el_recodo_song,
        person: el_recodo_person3
      ),
      ExternalCatalog::ElRecodo::PersonRole.create!(
        role: "author",
        song: el_recodo_song,
        person: el_recodo_person4
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

        expect(recording.composition.title).to eq("Vuelve la serenata")
      end
    end

    context "when building a new recording with artist metadata" do
      it "creates a new recording with the correct artist" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        singer_names = recording.recording_singers.map { _1.person.name }
        expect(singer_names).to include("Jorge Casal", "Raúl Berón")
      end
    end

    context "when building a new recording with composer metadata" do
      it "creates a new recording with the correct composer" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.composers.first.name).to eq("Aníbal Troilo")
      end
    end

    context "when building a new recording with lyricist metadata" do
      it "creates a new recording with the correct lyricist" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.lyricists.first.name).to eq("Cátulo Castillo")
      end
    end

    context "when building a new recording with genre metadata" do
      it "creates a new recording with the correct genre" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.genre.name).to eq("Vals")
      end
    end

    context "when building a new recording with album artist metadata" do
      it "creates a new recording with the correct album artist" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.orchestra.name).to eq("Aníbal Troilo")
      end
    end

    context "when building a new recording with year metadata" do
      it "creates a new recording with the correct year" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.recorded_date.year).to eq(1953)
      end
    end

    context "when building a new recording with barcode metadata" do
      it "creates a new recording with the correct barcode" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.el_recodo_song.ert_number).to eq(2918)
      end
    end

    context "when building a new recording with date metadata" do
      it "creates a new recording with the correct date" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.recorded_date).to eq("1953-01-01".to_date)
      end
    end

    context "when creating a new recording without duplicates" do
      it "does not create duplicate compositions" do
        existing_composition = Composition.create!(title: "Vuelve la serenata")
        person = Person.create!(name: "Aníbal Troilo")

        existing_composition.composers << person
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.id).to eq(existing_composition.id)
      end

      it "does not create duplicate genres" do
        existing_genre = Genre.create!(name: "Vals")
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.genre.id).to eq(existing_genre.id)
      end

      it "does not create duplicate record labels" do
        existing_record_label = RecordLabel.create!(name: "tk")
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
