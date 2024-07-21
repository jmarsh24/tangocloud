require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::SongBuilder do
  describe "#build_song" do
    before do
      stub_request(:get, "https://www.el-recodo.com/w_pict/maestros/julio%20cesar%20curi")
        .to_return(
          status: 200,
          body: File.read(Rails.root.join("spec/fixtures/files/di_sarli.jpg")),
          headers: {"Content-Type" => "image/jpeg"}
        )
    end

    it "creates a song with the given metadata and people" do
      el_recodo_song = create(:el_recodo_song)
      person = ExternalCatalog::ElRecodo::SongScraper::Person.new(
        name: "Julio César Curi",
        role: "author",
        url: "music?O=Julio%20C%C3%A9sar%20CURI&lang=en"
      )

      person_scraper = ExternalCatalog::ElRecodo::PersonScraper.new(cookies: "some_cookie")
      allow(person_scraper).to receive(:fetch).and_return(
        ExternalCatalog::ElRecodo::PersonScraper::Person.new(
          name: "Julio César Curi",
          birth_date: Date.new(1903, 1, 1),
          death_date: Date.new(1977, 1, 1),
          real_name: "Julio César Curi",
          nicknames: ["El Cachafaz"],
          place_of_birth: "Buenos Aires",
          path: "music?O=Julio%20C%C3%A9sar%20CURI&lang=en",
          image_path: "w_pict/maestros/julio%20cesar%20curi"
        )
      )

      song_buider = ExternalCatalog::ElRecodo::SongBuilder.new(
        cookies: "some_cookie",
        person_scraper:
      )

      metadata = ExternalCatalog::ElRecodo::SongScraper::Metadata.new(
        ert_number: el_recodo_song.ert_number,
        date: Date.new(1942, 1, 1),
        title: "La cumparsita",
        orchestra: "Carlos Di Sarli",
        style: "Tango",
        label: "RCA Victor",
        matrix: "Bb 8",
        disk: "RCA Victor 60-1001",
        instrumental: false,
        speed: 78,
        duration: 90,
        lyrics: "Some lyrics",
        lyrics_year: 1942,
        synced_at: Time.current,
        page_updated_at: Time.current
      )

      song = song_buider.build_song(
        ert_number: el_recodo_song.ert_number,
        metadata:,
        people: [person]
      )

      expect(song.title).to eq("La cumparsita")
      expect(song.orchestra).to eq("Carlos Di Sarli")
      expect(song.date).to eq(Date.new(1942, 1, 1))
      expect(song.style).to eq("Tango")
      expect(song.label).to eq("RCA Victor")
      expect(song.matrix).to eq("Bb 8")
      expect(song.disk).to eq("RCA Victor 60-1001")
      expect(song.instrumental).to be(false)
      expect(song.speed).to eq(78)
      expect(song.duration).to eq(90)
      expect(song.lyrics).to eq("Some lyrics")
      expect(song.lyrics_year).to eq(1942)
      expect(song.synced_at).to be_within(1.second).of(Time.current)
      expect(song.page_updated_at).to be_within(1.second).of(Time.current)
    end
  end
end
