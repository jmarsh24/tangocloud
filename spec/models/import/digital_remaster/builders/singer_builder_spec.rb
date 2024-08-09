require "rails_helper"

RSpec.describe Import::DigitalRemaster::Builders::SingerBuilder do
  describe "#build" do
    context "when the name does not exist" do
      it "creates a new person" do
        singer_builder = described_class.new(name: "Osvaldo Pugliese")
        singers = singer_builder.build

        expect(Person.find_by(name: "Osvaldo Pugliese")).to be_present
        expect(singers.first.person.name).to eq("Osvaldo Pugliese")
        expect(singers.first.soloist).to be_falsey
      end

      context "when the name has 'Dir.' in it" do
        it "creates a new person with the 'Dir.' removed and sets soloist to true" do
          singer_builder = described_class.new(name: "Dir. Osvaldo Pugliese")
          singers = singer_builder.build

          expect(Person.find_by(name: "Osvaldo Pugliese")).to be_present
          expect(singers.first.person.name).to eq("Osvaldo Pugliese")
          expect(singers.first.soloist).to be_truthy
        end
      end

      context "when the name is 'instrumental'" do
        it "does not create a person" do
          singer_builder = described_class.new(name: "instrumental")
          singers = singer_builder.build

          expect(singers).to be_empty
        end
      end

      context "when the name is blank" do
        it "does not create a person" do
          singer_builder = described_class.new(name: "")
          singers = singer_builder.build

          expect(singers).to be_empty
        end
      end

      context "when there are multiple names separated by a comma" do
        it "creates new persons for each name" do
          singer_builder = described_class.new(name: "Osvaldo Pugliese, Anibal Troilo")
          singers = singer_builder.build

          expect(Person.find_by(name: "Osvaldo Pugliese")).to be_present
          expect(Person.find_by(name: "Anibal Troilo")).to be_present

          expect(singers.map { |s| s.person.name }).to include("Osvaldo Pugliese", "Anibal Troilo")
          expect(singers.all? { |s| s.soloist == false }).to be true
        end
      end
    end

    context "when the person already exists" do
      it "finds the existing person" do
        Person.create!(name: "Osvaldo Pugliese")
        singer_builder = described_class.new(name: "Osvaldo Pugliese")
        singers = singer_builder.build

        expect(Person.where(name: "Osvaldo Pugliese").count).to eq(1)
        expect(singers.first.person.name).to eq("Osvaldo Pugliese")
        expect(singers.first.soloist).to be_falsey
      end

      context "when the name has 'Dir.' in it" do
        it "finds the existing person with the 'Dir.' removed and sets soloist to true" do
          Person.create!(name: "Osvaldo Pugliese")
          singer_builder = described_class.new(name: "Dir. Osvaldo Pugliese")
          singers = singer_builder.build

          expect(Person.where(name: "Osvaldo Pugliese").count).to eq(1)
          expect(singers.first.person.name).to eq("Osvaldo Pugliese")
          expect(singers.first.soloist).to be_truthy
        end
      end

      context "when there are multiple names separated by a comma and some exist" do
        it "finds existing persons and creates new ones for names that don't exist" do
          Person.create!(name: "Osvaldo Pugliese")
          singer_builder = described_class.new(name: "Osvaldo Pugliese, Anibal Troilo")
          singers = singer_builder.build

          expect(Person.where(name: "Osvaldo Pugliese").count).to eq(1)
          expect(Person.where(name: "Anibal Troilo").count).to eq(1)

          expect(singers.map { |s| s.person.name }).to include("Osvaldo Pugliese", "Anibal Troilo")
        end
      end
    end
  end
end
