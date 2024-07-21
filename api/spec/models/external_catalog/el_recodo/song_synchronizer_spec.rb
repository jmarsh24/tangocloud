require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::SongSynchronizer do
  describe "#sync_song" do
    let(:cookies) { "some_cookie" }
    let(:song_scraper) { ExternalCatalog::ElRecodo::SongScraper }
    let(:song_synchronizer) { ExternalCatalog::ElRecodo::SongSynchronizer.new(cookies:, song_scraper:) }
    let(:metadata) do
      ExternalCatalog::ElRecodo::SongScraper::Metadata.new(
        ert_number: 1,
        title: "Te burlas tristeza",
        orchestra: "Rodoflo Biagi",
        date: Date.new(1960, 7, 28),
        style: "Tango",
        label: "Odeon",
        matrix: "Odeon 18307",
        lyrics: nil,
        lyrics_year: nil,
        disk: nil,
        instrumental: true,
        speed: nil,
        duration: 60,
        synced_at: Time.now,
        page_updated_at: Time.now
      )
    end
    let(:result) do
      ExternalCatalog::ElRecodo::SongScraper::Result.new(
        metadata:,
        members: [
          ExternalCatalog::ElRecodo::SongScraper::Person.new(
            name: "Hugo Duval",
            role: "singer",
            url: "https://www.el-recodo.com/music?Ar=Julio%20C%C3%A9sar%20Curi&lang=en"
          )
        ],
        tags: []
      )
    end

    before do
      allow(song_scraper).to receive(:fetch).and_return(result)
      stub_request(:get, "https://www.el-recodo.com/music?Ar=Julio%20C%C3%A9sar%20Curi&lang=en")
        .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_person_julio_cesar_curi.html")))
    end

    it "fetches the song data and builds a new el recodo song" do
      freeze_time do
        stub_config el_recodo_request_delay: 0

        song_synchronizer.sync_song(ert_number: 1)

        song = ElRecodoSong.find_by(ert_number: 1)
        expect(song).to be_present
        expect(song.title).to eq("Te burlas tristeza")
        expect(song.orchestra).to eq("Rodoflo Biagi")
        expect(song.date).to eq(Date.new(1960, 7, 28))
        expect(song.style).to eq("Tango")
        expect(song.label).to eq("Odeon")
        expect(song.matrix).to eq("Odeon 18307")
        expect(song.lyrics).to be_nil
        expect(song.lyrics_year).to be_nil
        expect(song.disk).to be_nil
        expect(song.instrumental).to be_truthy
        expect(song.speed).to be_nil
        expect(song.duration).to eq(60)
        expect(song.synced_at).to be_within(1.second).of(Time.now)
        expect(song.page_updated_at).to be_within(1.second).of(Time.now)
        expect(song.people.count).to eq(1)
        expect(song.people.first.name).to eq("Julio César Curi")
      end
    end
  end
end
