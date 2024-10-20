require "rails_helper"

RSpec.describe Import::DigitalRemaster::Builders::RecordingBuilder do
  let(:recording_metadata) do
    Import::DigitalRemaster::Builder::RecordingMetadata.new(
      date: "1950-09-22",
      title: "Nunca te podré olvidar",
      genre: "Tango",
      artist: "Carlos Dante",
      composer: "Víctor Braña",
      lyricist: "Enrique Gaudino",
      album_artist: "Alfredo De Angelis",
      album_artist_sort: "De Angelis, Alfredo",
      year: "1939",
      grouping: "Tango Tunes",
      catalog_number: "TC3674",
      barcode: "ERT-9479",
      organization: nil,
      lyrics: "Letra de la canción"
    )
  end

  let(:el_recodo_song) {
    build(:external_catalog_el_recodo_song,
      title: "Nunca te podré olvidar",
      ert_number: 9479,
      label: "Odeon",
      duration: 179)
  }

  let(:el_recodo_orchestra) {
    ExternalCatalog::ElRecodo::Orchestra.create!(
      name: "Alfredo De Angelis",
      song: el_recodo_song
    )
  }

  let(:el_recodo_person) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Carlos Dante",
      birth_date: "1906-03-12",
      death_date: "1985-04-28",
      nicknames: ["Testori, Carlos Dante"],
      place_of_birth: "Buenos Aires Argentina"
    )
  }

  let(:el_recodo_person2) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Victor Braña",
      birth_date: "1911-06-11",
      death_date: "1989-05-05",
      place_of_birth: "Villa Domínico (Buenos Aires) Argentina"
    )
  }

  let(:el_recodo_person3) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Enrique Gaudino",
      birth_date: "1899-04-25",
      death_date: "1974-10-06",
      place_of_birth: "San Miguel del Monte (Buenos Aires) Argentina"
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

        expect(recording.composition.title).to eq("Nunca te podré olvidar")
      end
    end

    context "when building a new recording with artist metadata" do
      it "creates a new recording with the correct artist" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        singer_names = recording.recording_singers.map { _1.person.name }
        expect(singer_names).to include("Carlos Dante")
      end
    end

    context "when building a new recording with composer metadata" do
      it "does not create duplicate composers" do
        existing_composition = Composition.create!(title: "Nunca te podré olvidar")
        person = Person.create!(name: "Víctor Braña")
        existing_composition.composers << person
        builder = described_class.new(recording_metadata:)

        recording = builder.build

        expect(recording.composition.composers.first.id).to eq(person.id)
      end
      it "creates a new recording with the correct composer" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.composers.first.name).to eq("Víctor Braña")
      end
    end

    context "when building a new recording with lyricist metadata" do
      it "creates a new recording with the correct lyricist" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.composition.lyricists.first.name).to eq("Enrique Gaudino")
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

        expect(recording.orchestra.name).to eq("Alfredo De Angelis")
      end
    end

    context "when building a new recording with year metadata" do
      it "creates a new recording with the correct year" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.recorded_date.year).to eq(1950)
      end
    end

    context "when building a new recording with barcode metadata" do
      it "creates a new recording with the correct barcode" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.el_recodo_song.ert_number).to eq(9479)
      end
    end

    context "when building a new recording with date metadata" do
      it "creates a new recording with the correct date" do
        builder = described_class.new(recording_metadata:)
        recording = builder.build

        expect(recording.recorded_date).to eq("1950-09-22".to_date)
      end
    end

    context "when creating a new recording without duplicates" do
      it "does not create duplicate compositions" do
        existing_composition = Composition.create!(title: "Nunca te podré olvidar")
        person = Person.create!(name: "Víctor Braña")
        existing_composition.composers << person
        builder = described_class.new(recording_metadata:)

        recording = builder.build

        expect(recording.composition.id).to eq(existing_composition.id)
      end

      it "does not create duplicate genres" do
        existing_genre = Genre.find_by(name: "Tango")
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
