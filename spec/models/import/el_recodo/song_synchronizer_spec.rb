# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::ElRecodo::SongSynchronizer do
  describe "#sync_songs" do
    it "enqueues jobs for the specified range of music IDs" do
      expect do
        Import::ElRecodo::SongSynchronizer.new.sync_songs(from: 1, to: 2, interval: 20)
      end.to have_enqueued_job(Import::ElRecodo::SyncSongJob).exactly(2).times

      expect(Import::ElRecodo::SyncSongJob).to have_been_enqueued.with(music_id: 1, interval: 20)
      expect(Import::ElRecodo::SyncSongJob).to have_been_enqueued.with(music_id: 2, interval: 20)
    end
  end

  describe "#sync_song" do
    before do
      stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en").to_return(status: 200, body: File.read("spec/fixtures/el_recodo_music_id_1.html"))
    end

    context "when the song does not exist" do
      it "creates a new song" do
        freeze_time
        expect { Import::ElRecodo::SongSynchronizer.new.sync_song(music_id: 1) }.to change(ElRecodoSong, :count).by(1)
        song = ElRecodoSong.find_by(music_id: 1)

        expect(song.ert_number).to eq(1)
        expect(song.title).to eq("Te burlas tristeza")
        expect(song.date).to eq(Date.new(1960, 7, 28))
        expect(song.style).to eq("TANGO")
        expect(song.orchestra).to eq("Rodolfo BIAGI")
        expect(song.singer).to eq("Hugo Duval")
        expect(song.composer).to eq("Edmundo Baya")
        expect(song.author).to eq("Julio César Curi")
        expect(song.label).to eq("Columbia")
        expect(song.music_id).to eq(1)
        expect(song.normalized_title).to eq("te burlas tristeza")
        expect(song.normalized_orchestra).to eq("rodolfo biagi")
        expect(song.normalized_singer).to eq("hugo duval")
        expect(song.normalized_composer).to eq("edmundo baya")
        expect(song.normalized_author).to eq("julio cesar curi")
        expect(song.search_data).to eq("te burlas tristeza rodolfo biagi hugo duval edmundo baya julio cesar curi")
        expect(song.page_updated_at).to eq(Time.zone.parse("2018-10-14 02:00:00.000000000 +0200"))
        expect(song.synced_at).to eq(Time.zone.now)
      end

      it "updates an existing song" do
        ElRecodoSong.create!(
          ert_number: 0,
          music_id: 1,
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

        expect { Import::ElRecodo::SongSynchronizer.new.sync_song(music_id: 1) }.to change { ElRecodoSong.find_by(music_id: 1).title }.from("foo").to("Te burlas tristeza")
        expect { Import::ElRecodo::SongSynchronizer.new.sync_song(music_id: 1) }.not_to change { ElRecodoSong.all.count }
      end
    end

    context "when the song already exists" do
      it "updates the existing song with the new attributes" do
        existing_song = ElRecodoSong.create!(
          music_id: 1,
          ert_number: 1,
          title: "Old Title",
          date: Date.new(1960, 7, 28),
          page_updated_at: 1.week.ago
        )

        expect { Import::ElRecodo::SongSynchronizer.new.sync_song(music_id: 1) }.not_to change(ElRecodoSong, :count)
        existing_song.reload

        expect(existing_song.title).to eq("Te burlas tristeza")
      end
    end
  end
end
