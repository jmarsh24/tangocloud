# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::ElRecodo::SongScraper do
  describe "#metadata" do
    let(:music_id) { 1 }
    let(:song_scraper) { described_class.new(music_id:) }
    let(:html_fixture_path) { Rails.root.join("spec/fixtures/el_recodo_song.html") }
    let(:html_content) { File.read(html_fixture_path) }

    before do
      stub_request(:get, "https://www.el-recodo.com/music?id=#{music_id}&lang=en")
        .to_return(status: 200, body: html_content)
    end

    it "fetches and parses song metadata correctly" do
      metadata = song_scraper.metadata

      expect(metadata.ert_number).to eq(1)
      expect(metadata.title).to eq("Te burlas tristeza")
      expect(metadata.date).to eq(Date.new(1960, 7, 28))
      expect(metadata.style).to eq("TANGO")
      expect(metadata.orchestra).to eq("Rodolfo BIAGI")
      expect(metadata.singer).to eq("Hugo Duval")
      expect(metadata.composer).to eq("Edmundo Baya")
      expect(metadata.author).to eq("Julio César Curi")
      expect(metadata.label).to eq("Columbia")
      expect(metadata.music_id).to eq(1)
      expect(metadata.page_updated_at).to eq(Time.zone.parse("2018-10-14 02:00:00.000000000 +0200"))
    end

    context "when the server returns Too Many Requests (429)" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=#{music_id}&lang=en")
          .to_return(status: 429)
      end

      it "raises a TooManyRequestsError" do
        expect { song_scraper.metadata }.to raise_error(Import::ElRecodo::SongScraper::TooManyRequestsError)
      end
    end

    context "when the page is not found (404)" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=#{music_id}&lang=en")
          .to_return(status: 404)
      end

      it "raises a PageNotFoundError" do
        expect { song_scraper.metadata }.to raise_error(Import::ElRecodo::SongScraper::PageNotFoundError)
      end
    end

    context "when the page is not found (302)" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=#{music_id}&lang=en")
          .to_return(status: 302)
      end

      it "raises a PageNotFoundError" do
        expect { song_scraper.metadata }.to raise_error(Import::ElRecodo::SongScraper::PageNotFoundError)
      end
    end
  end
end
