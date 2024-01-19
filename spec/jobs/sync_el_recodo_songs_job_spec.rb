# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncElRecodoSongsJob, type: :job do
  describe "#perform" do
    it "calls sync_songs on ElRecodoSong" do
      expect(ElRecodoSong).to receive(:sync_songs)

      described_class.perform_now
    end
  end
end
