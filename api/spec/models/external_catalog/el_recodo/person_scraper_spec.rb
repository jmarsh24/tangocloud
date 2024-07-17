require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::PersonScraper do
  describe "#fetch" do
    before do
      stub_request(:get, "https://www.el-recodo.com/music?O=Juan%20D'ARIENZO&lang=en")
        .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_person_juan_darienzo.html")))
    end

    it "returns a person object with the parsed data" do
      person_scraper = ExternalCatalog::ElRecodo::PersonScraper.new(cookies: "some_cookie")
      result = person_scraper.fetch(path: "music?O=Juan D'ARIENZO&lang=en")

      expect(result.name).to eq("Juan D'Arienzo")
      expect(result.birth_date).to eq(Date.new(1900, 12, 14))
      expect(result.death_date).to eq(Date.new(1976, 1, 14))
      expect(result.real_name).to eq("D'Arienzo, Juan")
      expect(result.nicknames).to eq(["El Rey del compás"])
      expect(result.place_of_birth).to eq("Buenos Aires Argentina")
      expect(result.path).to eq("music?O=Juan D'ARIENZO&lang=en")
      expect(result.image_path).to eq("w_pict/maestros/juan%20d'arienzo")
    end
  end
end
