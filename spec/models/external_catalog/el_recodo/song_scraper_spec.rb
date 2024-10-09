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
        expect(metadata.orchestra_name).to eq("Juan D'Arienzo")
        expect(metadata.orchestra_image_path).to eq("w_pict/maestros/juan%20d'arienzo")
        expect(metadata.orchestra_path).to eq("music?O=Juan%20D'ARIENZO&lang=en")

        members = result.members

        expect(members).to include(
          have_attributes(name: "Hector Varela", role: "arranger", url: "music?M=Hector%20Varela&lang=en"),
          have_attributes(name: "Fulvio Salamanca", role: "piano", url: "music?M=Fulvio%20Salamanca&lang=en"),
          have_attributes(name: "Rodolfo Velo", role: "piano", url: "music?M=Rodolfo%20Velo&lang=en"),
          have_attributes(name: "Juancito Diaz", role: "piano", url: "music?M=Juancito%20Diaz&lang=en"),
          have_attributes(name: "Olindo Sinibaldi", role: "doublebass", url: "music?M=Olindo%20Sinibaldi&lang=en"),
          have_attributes(name: "Hector Varela", role: "bandoneon", url: "music?M=Hector%20Varela&lang=en"),
          have_attributes(name: "Eladio Blanco", role: "bandoneon", url: "music?M=Eladio%20Blanco&lang=en"),
          have_attributes(name: "José Di Pilato", role: "bandoneon", url: "music?M=Jos%C3%A9%20di%20Pilato&lang=en"),
          have_attributes(name: "Alberto San Miguel", role: "bandoneon", url: "music?M=Alberto%20San%20Miguel&lang=en"),
          have_attributes(name: "Salvador Alonso", role: "bandoneon", url: "music?M=Salvador%20Alonso&lang=en"),
          have_attributes(name: "Luis Pinotti", role: "bandoneon", url: "music?M=Luis%20Pinotti&lang=en"),
          have_attributes(name: "Cayetano Puglisi", role: "violin", url: "music?M=Cayetano%20Puglisi&lang=en"),
          have_attributes(name: "Blas Pensato", role: "violin", url: "music?M=Blas%20Pensato&lang=en"),
          have_attributes(name: "Jaime Ferrer", role: "violin", url: "music?M=Jaime%20Ferrer&lang=en"),
          have_attributes(name: "Clemente Arnaiz", role: "violin", url: "music?M=Clemente%20Arnaiz&lang=en"),
          have_attributes(name: "Héctor Mauré", role: "singer", url: "music?C=H%C3%A9ctor%20Maur%C3%A9&lang=en"),
          have_attributes(name: "Juan D'Arienzo", role: "composer", url: "music?Cr=Juan%20D'Arienzo&lang=en"),
          have_attributes(name: "Luis Rubistein", role: "author", url: "music?Ar=Luis%20Rubistein&lang=en")
        )

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
        expect(metadata.instrumental).to be_falsey
        expect(metadata.duration).to eq(184) # assuming duration is converted to seconds
        expect(metadata.lyrics).not_to be_empty
        expect(metadata.page_updated_at).to eq(DateTime.parse("2013-08-15 03:47:00"))

        expect(result.members).to include(
          have_attributes(name: "Rodolfo Sciammarella", role: "composer", url: "music?Cr=Rodolfo%20Sciammarella&lang=en"),
          have_attributes(name: "Rodolfo Sciammarella", role: "author", url: "music?Ar=Rodolfo%20Sciammarella&lang=en"),
          have_attributes(name: "Alberto Castillo", role: "soloist", url: "music?O=Alberto%20CASTILLO&lang=en"),
          have_attributes(name: "Emilio Balcarce", role: "director", url: "music?C=Dir.%20Emilio%20Balcarce&lang=en")
        )

        expect(result.tags).to be_empty
      end
    end

    context "for biagi song" do
      before do
        music_1_html = Rails.root.join("spec/fixtures/html/el_recodo_music_id_1.html")
        stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en")
          .to_return(status: 200, body: File.read(music_1_html))
      end

      it "fetches and parses song metadata correctly" do
        scraper = ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie")
        result = scraper.fetch(ert_number: 1)
        metadata = result.metadata

        expect(metadata.ert_number).to eq(1)
        expect(metadata.title).to eq("Te burlas tristeza")
        expect(metadata.date).to eq(Date.new(1960, 7, 28))
        expect(metadata.style).to eq("Tango")
        expect(metadata.label).to eq("Columbia")
        expect(metadata.matrix).to be_nil
        expect(metadata.disk).to be_nil
        expect(metadata.instrumental).to be_falsey
        expect(metadata.speed).to be_nil
        expect(metadata.duration).to eq(144)
        expect(metadata.lyrics).to include("Tristeza...\nCon el vino de mi mesa")
        expect(metadata.synced_at).to be_within(1.second).of(Time.zone.now)
        expect(metadata.page_updated_at).to eq(DateTime.parse("2018-10-14 22:04:00"))
        expect(metadata.orchestra_name).to eq("Rodolfo Biagi")
        expect(metadata.orchestra_image_path).to eq("w_pict/maestros/rodolfo%20biagi")

        members = result.members

        expect(members).to include(
          have_attributes(name: "Hugo Duval", role: "singer", url: "music?C=Hugo%20Duval&lang=en"),
          have_attributes(name: "Edmundo Baya", role: "composer", url: "music?Cr=Edmundo%20Baya&lang=en"),
          have_attributes(name: "Julio César Curi", role: "author", url: "music?Ar=Julio%20C%C3%A9sar%20Curi&lang=en")
        )

        expect(result.tags).to be_empty
      end
    end

    context "for instrumental songs" do
      before do
        music_3_html = Rails.root.join("spec/fixtures/html/el_recodo_music_id_3.html")
        stub_request(:get, "https://www.el-recodo.com/music?id=3&lang=en")
          .to_return(status: 200, body: File.read(music_3_html))
      end

      it "does not return instrumental as person" do
        scraper = ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie")
        result = scraper.fetch(ert_number: 3)
        metadata = result.metadata

        expect(metadata.ert_number).to eq(3)
        expect(metadata.title).to eq("La maleva")
        expect(metadata.date).to eq(Date.new(1939, 3, 24))
        expect(metadata.style).to eq("Tango")
        expect(metadata.label).to eq("Odeon")
        expect(metadata.matrix).to be_nil
        expect(metadata.disk).to be_nil
        expect(metadata.instrumental).to be_truthy
        expect(metadata.speed).to eq("67")
        expect(metadata.duration).to eq(154)
        expect(metadata.lyrics).to include("Maleva que has vuelto al nido")
        expect(metadata.synced_at).to be_within(1.second).of(Time.zone.now)
        expect(metadata.page_updated_at).to eq(DateTime.parse("2013-05-28 00:58:00"))

        members = result.members

        expect(members).not_to include(have_attributes(name: "Instrumental", role: "singer", url: "%23"))

        expect(members).to include(
          have_attributes(name: "Antonio Buglione", role: "composer", url: "music?Cr=Antonio%20Buglione&lang=en"),
          have_attributes(name: "Mario Pardo", role: "author", url: "music?Ar=Mario%20Pardo&lang=en")
        )

        tags = result.tags
        expect(tags).to include(
          have_attributes(name: "Playful Rhythm", url: "music?t1=Rj&lang=en"),
          have_attributes(name: "Bandoneon Variation", url: "music?t1=Sbv&lang=en"),
          have_attributes(name: "Piano Solo", url: "music?t1=Sps&lang=en")
        )
      end
    end

    context "when date is not valid" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=2896&lang=en")
          .to_return(status: 200, body: Rails.root.join("spec/fixtures/html/el_recodo_music_id_2896.html"))
        stub_request(:get, "https://www.el-recodo.com/music?id=4975&lang=en")
          .to_return(status: 200, body: Rails.root.join("spec/fixtures/html/el_recodo_music_id_4975.html"))
      end

      it "converts the date to the first day of the month or day" do
        result = ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie").fetch(ert_number: 2896)

        expect(result.metadata.date).to eq(Date.new(1950, 11, 1))
      end

      it "returns nil for page_updated_at when the date is not valid" do
        result = ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie").fetch(ert_number: 4975)

        expect(result.metadata.page_updated_at).to be_nil
      end
    end

    context "when there is no image" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=5794&lang=en")
          .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_music_id_5794.html")))
      end

      it "does not save the image path" do
        song_scraper = ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie")
        result = song_scraper.fetch(ert_number: 5794)

        expect(result.metadata.orchestra_image_path).to be_nil
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

    context "when the page is not found (302)" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en")
          .to_return(status: 302)
      end

      it "creates an ElRecodoEmptyPage" do
        ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie").fetch(ert_number: 1)
        expect(ExternalCatalog::ElRecodo::EmptyPage.find_by(ert_number: 1)).to be_present
      end
    end

    context "when the page is not found (503)" do
      it "raises a ServerError" do
        stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en")
          .to_return(status: 503)

        expect { ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie").fetch(ert_number: 1) }.to raise_error(ExternalCatalog::ElRecodo::SongScraper::ServerError)
      end
    end
  end
end
