require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::SongScraper do
  describe "#fetch" do
    context "for normal songs" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=3495&lang=en")
          .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_music_id_3495.html")))
      end

      it "fetches and parses song metadata correctly" do
        scraper = ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie")
        result = scraper.fetch(ert_number: 3495)

        metadata = result.metadata
        expect(metadata.ert_number).to eq(3495)
        expect(metadata.title).to eq("Ya lo ves")
        expect(metadata.date).to eq(Date.new(1941, 4, 28))
        expect(metadata.style).to eq("Tango")
        expect(metadata.label).to eq("RCA Victor")
        expect(metadata.matrix).to eq("39862")
        expect(metadata.disk).to eq("39273")
        expect(metadata.instrumental).to be_falsey
        expect(metadata.speed).to be_nil
        expect(metadata.duration).to eq(159)
        expect(metadata.lyrics).to include("La vida es tan extraña y es tan compleja")
        expect(metadata.synced_at).to be_within(1.second).of(Time.zone.now)
        expect(metadata.page_updated_at).to eq(DateTime.parse("2013-07-10 00:52"))

        musicians = result.musicians

        expect(musicians).to include(
          have_attributes(name: "Hector Varela", role: "arranger", url: "music?M=Hector Varela&lang=en"),
          have_attributes(name: "Fulvio Salamanca", role: "piano", url: "music?M=Fulvio Salamanca&lang=en"),
          have_attributes(name: "Rodolfo Velo", role: "piano", url: "music?M=Rodolfo Velo&lang=en"),
          have_attributes(name: "Juancito Diaz", role: "piano", url: "music?M=Juancito Diaz&lang=en"),
          have_attributes(name: "Olindo Sinibaldi", role: "doublebass", url: "music?M=Olindo Sinibaldi&lang=en"),
          have_attributes(name: "Hector Varela", role: "bandoneon", url: "music?M=Hector Varela&lang=en"),
          have_attributes(name: "Eladio Blanco", role: "bandoneon", url: "music?M=Eladio Blanco&lang=en"),
          have_attributes(name: "José Di Pilato", role: "bandoneon", url: "music?M=José di Pilato&lang=en"),
          have_attributes(name: "Alberto San Miguel", role: "bandoneon", url: "music?M=Alberto San Miguel&lang=en"),
          have_attributes(name: "Salvador Alonso", role: "bandoneon", url: "music?M=Salvador Alonso&lang=en"),
          have_attributes(name: "Luis Pinotti", role: "bandoneon", url: "music?M=Luis Pinotti&lang=en"),
          have_attributes(name: "Cayetano Puglisi", role: "violin", url: "music?M=Cayetano Puglisi&lang=en"),
          have_attributes(name: "Blas Pensato", role: "violin", url: "music?M=Blas Pensato&lang=en"),
          have_attributes(name: "Jaime Ferrer", role: "violin", url: "music?M=Jaime Ferrer&lang=en"),
          have_attributes(name: "Clemente Arnaiz", role: "violin", url: "music?M=Clemente Arnaiz&lang=en")
        )

        people = result.people

        expect(people).to include(
          have_attributes(name: "Juan D'Arienzo", role: "orchestra", url: "music?O=Juan D'ARIENZO&lang=en"),
          have_attributes(name: "Héctor Mauré", role: "singer", url: "music?C=Héctor Mauré&lang=en"),
          have_attributes(name: "Juan D'Arienzo", role: "composer", url: "music?Cr=Juan D'Arienzo&lang=en"),
          have_attributes(name: "Luis Rubistein", role: "author", url: "music?Ar=Luis Rubistein&lang=en")
        )

        expect(result.lyricist).to be_nil

        tags = result.tags
        expect(tags).to include(
          have_attributes(name: "Love", url: "music?t1=Lar&lang=en"),
          have_attributes(name: "Loss", url: "music?t1=Lpa&lang=en")
        )
      end
    end

    context "for songs with director and soloist" do
      before do
        music_6417_html = Rails.root.join("spec/fixtures/html/el_recodo_music_id_6417.html")
        stub_request(:get, "https://www.el-recodo.com/music?id=6417&lang=en")
          .to_return(status: 200, body: File.read(music_6417_html))
      end

      it "fetches and parses song metadata correctly" do
        scraper = ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie")
        result = scraper.fetch(ert_number: 6417)
        metadata = result.metadata

        expect(metadata.ert_number).to eq(6417)
        expect(metadata.title).to eq("Otra noche")
        expect(metadata.date).to eq(Date.new(1944, 8, 8))
        expect(metadata.style).to eq("Tango")
        expect(metadata.label).to be_nil
        expect(metadata.matrix).to be_nil
        expect(metadata.disk).to be_nil
        expect(metadata.duration).to eq(184) # assuming duration is converted to seconds
        expect(metadata.lyrics).not_to be_empty
        expect(metadata.page_updated_at).to eq(DateTime.parse("2013-08-15 03:47:00"))

        expect(result.musicians).to be_empty

        expect(result.people).to include(
          have_attributes(name: "Rodolfo Sciammarella", role: "composer", url: "music?Cr=Rodolfo Sciammarella&lang=en"),
          have_attributes(name: "Rodolfo Sciammarella", role: "author", url: "music?Ar=Rodolfo Sciammarella&lang=en"),
          have_attributes(name: "Alberto Castillo", role: "soloist", url: "music?O=Alberto CASTILLO&lang=en"),
          have_attributes(name: "Emilio Balcarce", role: "director", url: "music?C=Dir. Emilio Balcarce&lang=en")
        )

        expect(result.lyricist).to be_nil
        expect(result.tags).to be_empty
      end
    end

    context "when date is not valid" do
      before do
        music_2896_html = Rails.root.join("spec/fixtures/html/el_recodo_music_id_2896.html")
        stub_request(:get, "https://www.el-recodo.com/music?id=2896&lang=en")
          .to_return(status: 200, body: File.read(music_2896_html))
      end

      it "converts the date to the first day of the month or day" do
        result = ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie").fetch(ert_number: 2896)

        expect(result.metadata.date).to eq(Date.new(1950, 11, 1))
      end
    end

    context "when the server returns Too Many Requests (429)" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en")
          .to_return(status: 429)
      end

      it "raises a TooManyRequestsError" do
        expect { ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie").fetch(ert_number: 1) }.to raise_error(ExternalCatalog::ElRecodo::SongScraper::TooManyRequestsError)
      end
    end

    context "when the page is not found (404)" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en")
          .to_return(status: 404)
      end

      it "raises a PageNotFoundError" do
        expect { ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie").fetch(ert_number: 1) }.to raise_error(ExternalCatalog::ElRecodo::SongScraper::PageNotFoundError)
      end
    end

    context "when the page is not found (302)" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en")
          .to_return(status: 302)
      end

      it "raises a EmptyPageError" do
        expect { ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie").fetch(ert_number: 1) }.to raise_error(ExternalCatalog::ElRecodo::SongScraper::EmptyPageError)
      end
    end
  end
end
