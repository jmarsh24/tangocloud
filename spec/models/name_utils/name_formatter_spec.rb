require "rails_helper"

RSpec.describe NameUtils::NameFormatter, type: :model do
  describe ".format" do
    it "capitalizes 'juan d'arienzo' to 'Juan D'Arienzo'" do
      expect(described_class.format("juan d'arienzo")).to eq("Juan D'Arienzo")
    end

    it "capitalizes 'Carlos DI SARLI' to 'Carlos Di Sarli'" do
      expect(described_class.format("Carlos DI SARLI")).to eq("Carlos Di Sarli")
    end

    it "capitalizes 'Aníbal Troilo Y Astor Piazzolla' to 'Aníbal Troilo y Astor Piazzolla'" do
      expect(described_class.format("Aníbal Troilo Y Astor Piazzolla")).to eq("Aníbal Troilo y Astor Piazzolla")
    end
  end
end
