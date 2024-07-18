require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::SongSynchronizer do
  describe "#sync_song" do
    before do
      stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en").to_return(status: 200, body: File.read("spec/fixtures/html/el_recodo_music_id_1.html"))
    end

    context "when the song does not exist" do
      it "creates a new song" do
        freeze_time
        role_manager = ExternalCatalog::ElRecodo::RoleManager.new(cookies: "some_cookie")
        song_scraper = ExternalCatalog::ElRecodo::SongScraper.new(cookies: "some_cookie")
        allow(song_scraper).to receive(:fetch).and_return(
          ExternalCatalog::ElRecodo::SongScraper::Result.new(
            metadata: ExternalCatalog::ElRecodo::SongScraper::Metadata.new(
              ert_number: 1,
              title: "Te burlas tristeza",
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
            ),
            people: [
              ExternalCatalog::ElRecodo::SongScraper::Person.new(
                name: "Hugo Duval",
                role: "singer",
                url: "https://www.el-recodo.com/musician/1/hugo-duval"
              ),
              ExternalCatalog::ElRecodo::SongScraper::Person.new(
                name: "Edmundo Baya",
                role: "composer",
                url: "https://www.el-recodo.com/musician/2/edmundo-baya"
              ),
              ExternalCatalog::ElRecodo::SongScraper::Person.new(
                name: "Julio César Curi",
                role: "author",
                url: "https://www.el-recodo.com/musician/3/julio-cesar-curi"
              ),
              ExternalCatalog::ElRecodo::SongScraper::Person.new(
                name: "Rodolfo BIAGI",
                role: "orchestra",
                url: "https://www.el-recodo.com/musician/4/rodolfo-biagi"
              )
            ],
            musicians: [],
            lyricist: nil,
            tags: []
          )
        )
        expect(role_manager).to receive(:sync_people).with(
          el_recodo_song: an_instance_of(ElRecodoSong),
          people: [
            an_instance_of(ExternalCatalog::ElRecodo::SongScraper::Person),
            an_instance_of(ExternalCatalog::ElRecodo::SongScraper::Person),
            an_instance_of(ExternalCatalog::ElRecodo::SongScraper::Person),
            an_instance_of(ExternalCatalog::ElRecodo::SongScraper::Person)
          ]
        )
        ExternalCatalog::ElRecodo::SongSynchronizer.new(cookies: "some_cookie", song_scraper:, role_manager:).sync_song(ert_number: 1)
      end

      it "updates an existing song" do
      end
    end
  end
end
