require "rails_helper"

RSpec.describe Person, type: :model do
  describe ".find_or_create_by_normalized_name!" do
    let(:normalized_name) { "juan darienzo" }

    context "when the person already exists" do
      it "finds the person by normalized_name" do
        existing_person = Person.create!(name: "Juan D'Arienzo", normalized_name:)

        result = Person.find_or_create_by_normalized_name!("Juan D`Arienzo")

        expect(result).to eq(existing_person)
        expect(Person.where(normalized_name: normalized_name).count).to eq(1)
      end
    end

    context "when the person does not exist" do
      it "creates a new person with the normalized name" do
        expect {
          Person.find_or_create_by_normalized_name!("Juan D'Arienzo")
        }.to change { Person.count }.by(1)

        new_person = Person.find_by(normalized_name: normalized_name)
        expect(new_person.name).to eq("Juan D'Arienzo")
        expect(new_person.normalized_name).to eq(normalized_name)
      end
    end

    context "when the name has different formatting" do
      it "finds or creates a person with various name formats" do
        person1 = Person.find_or_create_by_normalized_name!("Juan D'Arienzo")
        person2 = Person.find_or_create_by_normalized_name!("Juan D`Arienzo")
        person3 = Person.find_or_create_by_normalized_name!("juan darienzo")

        expect(person1).to eq(person2)
        expect(person2).to eq(person3)
        expect(person1).to eq(person3)
        expect(person1.normalized_name).to eq(normalized_name)
      end
    end

    context "when the name has special characters or accents" do
      it "normalizes and creates or finds the person" do
        normalized_name_with_accent = "nicolas dalessandro"
        person_1 = Person.find_or_create_by_normalized_name!("Nicolás D´Alessandro")

        person = Person.find_or_create_by_normalized_name!("Nicolás D´Alessandro")

        expect(person.normalized_name).to eq(normalized_name_with_accent)
        expect(person).to eq(person_1)
      end
    end

    context "when the name has a different case" do
      it "formats the name" do
        Person.find_or_create_by_normalized_name!("Juan D'Arienzo")

        person = Person.find_or_create_by_normalized_name!("JUAN D'ARIENZO")

        expect(person.name).to eq("Juan D'Arienzo")
      end
    end

    context "when the name has a pseudonym" do
      it "finds or creates the person with the pseudonym" do
        person = Person.find_or_create_by_normalized_name!("F.Lila (Juan Polito)")

        expect(person.pseudonym).to eq("Juan Polito")
        expect(person.name).to eq("F.Lila")
      end
    end
  end
end

# == Schema Information
#
# Table name: people
#
#  id                  :uuid             not null, primary key
#  name                :string           default(""), not null
#  slug                :string
#  sort_name           :string
#  nickname            :string
#  birth_place         :string
#  normalized_name     :string           default(""), not null
#  pseudonym           :string
#  bio                 :text
#  birth_date          :date
#  death_date          :date
#  el_recodo_person_id :uuid
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  display_name        :string
#
