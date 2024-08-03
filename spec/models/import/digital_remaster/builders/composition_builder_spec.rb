require "rails_helper"

RSpec.describe Import::DigitalRemaster::Builders::CompositionBuilder do
  describe "#build" do
    context "when creating a new composition" do
      it "creates a new composition with a composer" do
        builder = described_class.new(
          composer_name: "Carlos Gardel",
          lyricist_name: nil,
          title: "El Dia Que Me Quieras",
          lyrics: nil
        )
        composition = builder.build

        expect(composition.title).to eq("El Dia Que Me Quieras")
        expect(composition.composers.first.name).to eq("Carlos Gardel")
      end

      it "creates a new composition with a lyricist" do
        builder = described_class.new(
          composer_name: nil,
          lyricist_name: "Alfredo Le Pera",
          title: "El Dia Que Me Quieras",
          lyrics: nil
        )
        composition = builder.build

        expect(composition.title).to eq("El Dia Que Me Quieras")
        expect(composition.lyricists.first.name).to eq("Alfredo Le Pera")
      end

      it "creates a new composition with lyrics" do
        builder = described_class.new(
          composer_name: nil,
          lyricist_name: nil,
          title: "El Dia Que Me Quieras",
          lyrics: "El día que me quieras..."
        )
        composition = builder.build

        expect(composition.title).to eq("El Dia Que Me Quieras")
        expect(composition.lyrics.first.text).to eq("El día que me quieras...")
      end

      it "creates a new composition with a composer, lyricist, and lyrics" do
        builder = described_class.new(
          composer_name: "Carlos Gardel",
          lyricist_name: "Alfredo Le Pera",
          title: "El Dia Que Me Quieras",
          lyrics: "El día que me quieras..."
        )
        composition = builder.build

        expect(composition.title).to eq("El Dia Que Me Quieras")
        expect(composition.composers.first.name).to eq("Carlos Gardel")
        expect(composition.lyricists.first.name).to eq("Alfredo Le Pera")
        expect(composition.lyrics.first.text).to eq("El día que me quieras...")
      end
    end

    context "when composition already exists" do
      let!(:existing_composition) { Composition.create!(title: "El Dia Que Me Quieras") }

      it "finds the existing composition" do
        builder = described_class.new(
          composer_name: "Carlos Gardel",
          lyricist_name: nil,
          title: "El Dia Que Me Quieras",
          lyrics: nil
        )
        composition = builder.build

        expect(composition.id).to eq(existing_composition.id)
        expect(composition.composers.first.name).to eq("Carlos Gardel")
      end

      it "adds a lyricist to an existing composition" do
        builder = described_class.new(
          composer_name: nil,
          lyricist_name: "Alfredo Le Pera",
          title: "El Dia Que Me Quieras",
          lyrics: nil
        )
        composition = builder.build

        expect(composition.id).to eq(existing_composition.id)
        expect(composition.lyricists.first.name).to eq("Alfredo Le Pera")
      end

      it "adds lyrics to an existing composition" do
        builder = described_class.new(
          composer_name: nil,
          lyricist_name: nil,
          title: "El Dia Que Me Quieras",
          lyrics: "El día que me quieras..."
        )
        composition = builder.build

        expect(composition.id).to eq(existing_composition.id)
        expect(composition.lyrics.first.text).to eq("El día que me quieras...")
      end

      it "does not create duplicate lyrics for an existing composition" do
        language = Language.find_or_create_by!(name: "spanish", code: "es")
        existing_composition.lyrics.create!(text: "El día que me quieras...", language:)

        builder = described_class.new(
          composer_name: nil,
          lyricist_name: nil,
          title: "El Dia Que Me Quieras",
          lyrics: "El día que me quieras..."
        )
        composition = builder.build

        expect(composition.id).to eq(existing_composition.id)
        expect(composition.lyrics.count).to eq(1)
        expect(composition.lyrics.first.text).to eq("El día que me quieras...")
      end
    end
  end
end
