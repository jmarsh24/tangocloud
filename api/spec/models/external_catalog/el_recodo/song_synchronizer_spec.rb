require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::SongSynchronizer do
  describe "#sync_songs" do
    it "enqueues jobs for the specified range of music IDs" do
      ElRecodoSong.destroy_all
      ElRecodoSong.create!(title: "random song", ert_number: 1, date: Date.today, page_updated_at: Time.now)
      ElRecodoSong.create!(title: "random song 2", ert_number: 2, date: Date.today, page_updated_at: Time.now)
      expect do
        ExternalCatalog::ElRecodo::SongSynchronizer.new.sync_songs
      end.to have_enqueued_job(ExternalCatalog::ElRecodo::SyncSongJob).exactly(2).times

      expect(ExternalCatalog::ElRecodo::SyncSongJob).to have_been_enqueued.with(ert_number: 1)
      expect(ExternalCatalog::ElRecodo::SyncSongJob).to have_been_enqueued.with(ert_number: 2)
    end
  end

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
        ElRecodoSong.create!(
          ert_number: 1,
          title: "foo",
          date: Date.today,
          page_updated_at: Time.now,
          style: "foo",
          orchestra: "foo",
          singer: "foo",
          composer: "foo",
          author: "foo",
          label: "foo",
          lyrics: "foo"
        )

        expect { ExternalCatalog::ElRecodo::SongSynchronizer.new(cookies: "some_cookie").sync_song(ert_number: 1) }.to change { ElRecodoSong.find_by(ert_number: 1).title }.from("foo").to("Te burlas tristeza")
        expect { ExternalCatalog::ElRecodo::SongSynchronizer.new(cookies: "some_cookie").sync_song(ert_number: 1) }.not_to change { ElRecodoSong.all.count }
      end
    end

    context "when the song already exists" do
      it "updates the existing song with the new attributes" do
        existing_song = ElRecodoSong.create!(
          ert_number: 1,
          title: "Old Title",
          date: Date.new(1960, 7, 28),
          page_updated_at: 1.week.ago
        )

        expect { ExternalCatalog::ElRecodo::SongSynchronizer.new(cookies: "some_cookie").sync_song(ert_number: 1) }.not_to change(ElRecodoSong, :count)
        existing_song.reload

        expect(existing_song.title).to eq("Te burlas tristeza")
      end
    end
  end
end
