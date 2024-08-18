require "rails_helper"

RSpec.describe NameUtils::NameNormalizer, type: :model do
  describe ".normalize" do
    context "when normalizing names with apostrophes or similar characters" do
      it "normalizes 'Juan D`Arienzo' to 'juan darienzo'" do
        expect(described_class.normalize("Juan D`Arienzo")).to eq("juan darienzo")
      end

      it "normalizes 'Nicolás D´Alessandro' to 'nicolas dalessandro'" do
        expect(described_class.normalize("Nicolás D´Alessandro")).to eq("nicolas dalessandro")
      end

      it "normalizes 'Ángel D'Agostino' to 'angel dagostino'" do
        expect(described_class.normalize("Ángel D'Agostino")).to eq("angel dagostino")
      end
    end

    context "when normalizing names with periods or parentheses" do
      it "normalizes 'F.Lila (Juan Polito)' to 'f lila juan polito'" do
        expect(described_class.normalize("F.Lila (Juan Polito)")).to eq("f lila juan polito")
      end

      it "normalizes 'Gabriel (Chula) Clausi' to 'gabriel chula clausi'" do
        expect(described_class.normalize("Gabriel (Chula) Clausi")).to eq("gabriel chula clausi")
      end
    end

    context "when normalizing names with hyphens" do
      it "normalizes 'Trío Palacio-Riverol-Cabral' to 'trio palacio riverol cabral'" do
        expect(described_class.normalize("Trío Palacio-Riverol-Cabral")).to eq("trio palacio riverol cabral")
      end
    end

    context "when normalizing names with diacritics" do
      it "normalizes 'María de la Fuente' to 'maria de la fuente'" do
        expect(described_class.normalize("María de la Fuente")).to eq("maria de la fuente")
      end

      it "normalizes 'Maria De La Fuente' to 'maria de la fuente'" do
        expect(described_class.normalize("Maria De La Fuente")).to eq("maria de la fuente")
      end
    end
  end
end
