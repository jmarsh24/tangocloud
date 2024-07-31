require "rails_helper"

RSpec.describe Import::AudioFile::ImportJob, type: :job do
describe "#perform" do
  it "creates a DigitalRemaster" do
    audio_file = create(:audio_file)

    Import::AudioFile::ImportJob.perform_now(audio_file)

    expect(DigitalRemaster.count).to eq(1)
  end
end
