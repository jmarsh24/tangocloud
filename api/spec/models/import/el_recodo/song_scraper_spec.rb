# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::ElRecodo::SongScraper do
  describe "#metadata" do
    context "for normal songs" do
      before do
        music_1_html = Rails.root.join("spec/fixtures/el_recodo_music_id_1.html")
        stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en")
          .to_return(status: 200, body: File.read(music_1_html))
      end

      it "fetches and parses song metadata correctly" do
        metadata = described_class.new(music_id: 1).metadata

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
    end

    context "for songs with director and soloist" do
      before do
        music_6417_html = Rails.root.join("spec/fixtures/el_recodo_music_id_6417.html")
        stub_request(:get, "https://www.el-recodo.com/music?id=6417&lang=en")
          .to_return(status: 200, body: File.read(music_6417_html))
      end

      it "fetches and parses song metadata correctly" do
        metadata = described_class.new(music_id: 6417).metadata
        expect(metadata.ert_number).to eq(6417)
        expect(metadata.title).to eq("Otra noche")
        expect(metadata.date).to eq(Date.new(1944, 8, 8))
        expect(metadata.style).to eq("TANGO")
        expect(metadata.orchestra).to be_nil
        expect(metadata.singer).to be_nil
        expect(metadata.composer).to eq("Rodolfo Sciammarella")
        expect(metadata.author).to eq("Rodolfo Sciammarella")
        expect(metadata.soloist).to eq("Alberto CASTILLO")
        expect(metadata.director).to eq("Dir. Emilio Balcarce")
        expect(metadata.label).to be_nil
        expect(metadata.music_id).to eq(6417)
        expect(metadata.page_updated_at).to eq(Time.zone.parse("2013-8-15 02:00:00.000000000 +0200"))
      end
    end

    context "when date is not valid" do
      before do
        music_2896_html = Rails.root.join("spec/fixtures/el_recodo_music_id_2896.html")
        stub_request(:get, "https://www.el-recodo.com/music?id=2896&lang=en")
          .to_return(status: 200, body: File.read(music_2896_html))
      end

      it "converts the date to the first day of the month or day" do
        metadata = described_class.new(music_id: 2896).metadata
        expect(metadata.date).to eq(Date.new(1950, 11, 1))
      end
    end

    context "when the server returns Too Many Requests (429)" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en")
          .to_return(status: 429)
      end

      it "raises a TooManyRequestsError" do
        expect { described_class.new(music_id: 1).metadata }.to raise_error(Import::ElRecodo::SongScraper::TooManyRequestsError)
      end
    end

    context "when the page is not found (404)" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en")
          .to_return(status: 404)
      end

      it "raises a PageNotFoundError" do
        expect { described_class.new(music_id: 1).metadata }.to raise_error(Import::ElRecodo::SongScraper::PageNotFoundError)
      end
    end

    context "when the page is not found (302)" do
      before do
        stub_request(:get, "https://www.el-recodo.com/music?id=1&lang=en")
          .to_return(status: 302)
      end

      it "raises a PageNotFoundError" do
        expect { described_class.new(music_id: 1).metadata }.to raise_error(Import::ElRecodo::SongScraper::PageNotFoundError)
      end
    end
  end
end
