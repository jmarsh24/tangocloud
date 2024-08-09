require "rails_helper"

RSpec.describe Import::DigitalRemaster::Builders::OrchestraBuilder do
  let(:el_recodo_song) { build(:external_catalog_el_recodo_song, title: "Volver a soñar") }
  let(:el_recodo_person) {
    ExternalCatalog::ElRecodo::Person.create!(
      name: "Carlos Gardel",
      birth_date: "1910-12-11",
      death_date: "1935-06-24",
      nicknames: ["El Zorzal"],
      place_of_birth: "Tacuarembó"
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
      ExternalCatalog::ElRecodo::PersonRole.create!(role: "piano", song: el_recodo_song, person: el_recodo_person),
      ExternalCatalog::ElRecodo::PersonRole.create!(role: "bandoneon", song: el_recodo_song, person: el_recodo_person2)
    ]
  }
  let(:orchestra_image) {
    fixture_file_upload(Rails.root.join("spec/fixtures/files/di_sarli.jpg"), "image/jpeg")
  }
  let(:orchestra_name) { "Orquesta Típica" }

  before do
    el_recodo_song.orchestra.image.attach(orchestra_image)
  end

  describe "#build" do
    context "when building a new orchestra" do
      it "creates a new orchestra with positions" do
        el_recodo_person_roles
        builder = described_class.new(
          orchestra_name:,
          el_recodo_song:
        )
        orchestra = builder.build

        expect(orchestra.name).to eq(orchestra_name)

        person = Person.find_by!(name: el_recodo_person.name)

        position = OrchestraPosition.find_by!(
          orchestra:,
          person:
        )

        expect(position).to be_present
        expect(position.orchestra_role.name).to eq("pianist")
      end

      context "when el_recodo_song has an orchestra" do
        it "creates a new orchestra with the el_recodo_orchestra" do
          el_recodo_orchestra = ExternalCatalog::ElRecodo::Orchestra.create!(name: "Orquesta Típica")
          el_recodo_song.update!(el_recodo_orchestra:)

          builder = described_class.new(
            orchestra_name:,
            el_recodo_song:
          )
          orchestra = builder.build

          expect(orchestra.el_recodo_orchestra).to eq(el_recodo_orchestra)
        end
      end

      it "attaches the orchestra image if available" do
        builder = described_class.new(
          orchestra_name:,
          el_recodo_song:
        )
        orchestra = builder.build

        expect(orchestra.image).to be_attached
      end

      it "raises an error for unrecognized roles" do
        el_recodo_person_roles.first.update!(role: "unknown")

        builder = described_class.new(
          orchestra_name:,
          el_recodo_song:
        )

        expect { builder.build }.to raise_error(Import::DigitalRemaster::Builders::OrchestraBuilder::UnrecognizedRoleError)
      end

      it "excludes roles defined in EXCLUDE_ROLES" do
        el_recodo_person_roles.first.update!(role: "arranger")

        builder = described_class.new(
          orchestra_name:,
          el_recodo_song:
        )
        orchestra = builder.build

        position = OrchestraPosition.find_by(
          orchestra:,
          person: el_recodo_person
        )

        expect(position).to be_nil
      end

      it "processes multiple person roles correctly" do
        el_recodo_person_roles
        builder = described_class.new(
          orchestra_name:,
          el_recodo_song:
        )
        orchestra = builder.build

        expect(orchestra.name).to eq(orchestra_name)
        expect(orchestra.orchestra_positions.count).to eq(2)
      end

      it "attaches the image even when added after song creation" do
        el_recodo_song.orchestra.image.attach(orchestra_image)
        builder = described_class.new(
          orchestra_name:,
          el_recodo_song:
        )
        orchestra = builder.build

        expect(orchestra.image).to be_attached
      end
    end

    context "when no el_recodo_song is provided" do
      it "creates an orchestra without positions and image" do
        builder = described_class.new(
          orchestra_name:
        )
        orchestra = builder.build

        expect(orchestra.name).to eq(orchestra_name)
        expect(orchestra.image).not_to be_attached
        expect(orchestra.orchestra_positions).to be_empty
      end
    end
  end
end
