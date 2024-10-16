require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::PersonScraper do
  describe "#fetch" do
    before do
      stub_request(:get, "https://www.el-recodo.com/music?O=Juan%20D'ARIENZO&lang=en")
        .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_person_juan_darienzo.html")))
      stub_request(:get, "https://www.el-recodo.com/music?Ar=Julio%20C%C3%A9sar%20Curi&lang=en")
        .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_person_julio_cesar_curi.html")))
      stub_request(:get, "https://www.el-recodo.com/music?Cr=Roberto%20Luratti&lang=en")
        .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_person_roberto_luratti.html")))
      stub_request(:get, "https://www.el-recodo.com/music?C=Dir.%20H%C3%A9ctor%20Mar%C3%ADa%20Artola&lang=en")
        .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_person_dir_hector_maria_artola.html")))
      stub_request(:get, "https://www.el-recodo.com/music?Cr=Jos%C3%A9%20Martinez&lang=en")
        .to_return(status: 301, headers: {"Location" => "https://www.el-recodo.com/music?Cr=Jos%C3%A9%20Mart%C3%ADnez&lang=en"})
      stub_request(:get, "https://www.el-recodo.com/music?Cr=Jos%C3%A9%20Mart%C3%ADnez&lang=en")
        .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_person_jose_martinez.html")))
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

    it "does not fail if only real name and name are present" do
      person_scaper = ExternalCatalog::ElRecodo::PersonScraper.new(cookies: "some_cookie")
      result = person_scaper.fetch(path: "music?Ar=Julio%20C%C3%A9sar%20Curi&lang=en")

      expect(result.name).to eq("Julio César Curi")
      expect(result.birth_date).to be_nil
      expect(result.death_date).to be_nil
      expect(result.real_name).to eq("Curi, Julio César")
      expect(result.nicknames).to eq([])
      expect(result.place_of_birth).to be_nil
      expect(result.path).to eq("music?Ar=Julio%20C%C3%A9sar%20Curi&lang=en")
      expect(result.image_path).to be_nil
    end

    it "does not fail only the name is present" do
      person_scraper = ExternalCatalog::ElRecodo::PersonScraper.new(cookies: "some_cookie")
      result = person_scraper.fetch(path: "music?Cr=Roberto%20Luratti&lang=en")

      expect(result.name).to eq("Roberto Luratti")
      expect(result.birth_date).to be_nil
      expect(result.death_date).to be_nil
      expect(result.real_name).to be_nil
      expect(result.nicknames).to eq([])
      expect(result.place_of_birth).to be_nil
      expect(result.path).to eq("music?Cr=Roberto%20Luratti&lang=en")
      expect(result.image_path).to be_nil
    end

    it "removes 'Dir. ' from the name" do
      person_scraper = ExternalCatalog::ElRecodo::PersonScraper.new(cookies: "some_cookie")
      result = person_scraper.fetch(path: "music?C=Dir.%20H%C3%A9ctor%20Mar%C3%ADa%20Artola&lang=en")

      expect(result.name).to eq("Héctor María Artola")
    end

    context "when the person already exists in the database" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?Cr=Jos%C3%A9%20Martinez&lang=en")
          .to_return(status: 301, headers: {"Location" => "https://www.el-recodo.com/music?Cr=Jos%C3%A9%20Mart%C3%ADnez&lang=en"})
        stub_request(:get, "https://www.el-recodo.com/music?Cr=Jos%C3%A9%20Mart%C3%ADnez&lang=en")
          .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_person_jose_martinez.html")))
      end

      it "fetches the person data and does not create a duplicate" do
        ExternalCatalog::ElRecodo::Person.create!(name: "José Martínez")
        person_scraper = ExternalCatalog::ElRecodo::PersonScraper.new(cookies: "some_cookie")
        result = person_scraper.fetch(path: "music?Cr=Jos%C3%A9%20Martinez&lang=en")

        expect(result.name).to eq("José Martínez")
        expect(result.birth_date).to eq(Date.new(1890, 1, 28))
        expect(result.death_date).to eq(Date.new(1939, 7, 27))
        expect(result.real_name).to eq("Martínez, José Julián")
        expect(result.nicknames).to eq(["Gallego"])
        expect(result.place_of_birth).to eq("Buenos Aires Argentina")
        expect(result.path).to eq("music?Cr=Jos%C3%A9%20Martinez&lang=en")
        expect(result.image_path).to be_nil
      end
    end

    context "when a date is not valid" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?Cr=N%C3%A9stor%20Portocarrero%20Vargas&lang=en")
          .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_person_nestor_portocarrero_vargas.html")))
      end

      it "does not fail" do
        person_scraper = ExternalCatalog::ElRecodo::PersonScraper.new(cookies: "some_cookie")
        result = person_scraper.fetch(path: "music?Cr=N%C3%A9stor%20Portocarrero%20Vargas&lang=en")

        expect(result.birth_date).to eq(Date.new(1905, 1, 1))
        expect(result.death_date).to eq(Date.new(1948, 11, 3))
      end
    end

    context "when the page does not exist" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?Cr=Non%20existent%20person&lang=en")
          .to_return(status: 404)
      end

      it "raises a PageNotFoundError" do
        person_scraper = ExternalCatalog::ElRecodo::PersonScraper.new(cookies: "some_cookie")

        expect { person_scraper.fetch(path: "music?Cr=Non%20existent%20person&lang=en") }.to raise_error(ExternalCatalog::ElRecodo::PersonScraper::PageNotFoundError)
      end
    end

    context "when the request limit is reached" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?Cr=Jos%C3%A9%20Martinez&lang=en")
          .to_return(status: 429)
      end

      it "raises a TooManyRequestsError" do
        person_scraper = ExternalCatalog::ElRecodo::PersonScraper.new(cookies: "some_cookie")

        expect { person_scraper.fetch(path: "music?Cr=Jos%C3%A9%20Martinez&lang=en") }.to raise_error(ExternalCatalog::ElRecodo::PersonScraper::TooManyRequestsError)
      end
    end

    context "when the server returns an error" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?Cr=Jos%C3%A9%20Martinez&lang=en")
          .to_return(status: 500)
      end

      it "raises a ServerError" do
        person_scraper = ExternalCatalog::ElRecodo::PersonScraper.new(cookies: "some_cookie")

        expect { person_scraper.fetch(path: "music?Cr=Jos%C3%A9%20Martinez&lang=en") }.to raise_error(ExternalCatalog::ElRecodo::PersonScraper::ServerError)
      end
    end
  end
end
