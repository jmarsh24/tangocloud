require "rails_helper"

RSpec.describe AudioProcessing::AudioFolderConverter, type: :service do
  let(:source_directory) { Rails.root.join("spec/fixtures") }
  let(:target_directory) { Rails.root.join("spec/fixtures_compressed") }
  let(:test_aif_file) { source_directory.join("tone.aif") }
  let(:test_flac_file) { source_directory.join("tone.flac") }
  let(:unprocessed_file) { source_directory.join("tone.m4a") }
  let(:converter) { instance_double(AudioProcessing::AudioConverter) }

  subject { described_class.new(source_directory:, target_directory:) }

  before do
    allow(Dir).to receive(:glob).with("#{source_directory}/**/*").and_return([test_aif_file.to_s, test_flac_file.to_s, unprocessed_file.to_s])
    allow(File).to receive(:directory?).and_return(false)
    allow(FileUtils).to receive(:mkdir_p)
    allow(AudioProcessing::AudioConverter).to receive(:new).and_return(converter)
    allow(converter).to receive(:convert)
  end

  describe "#convert_all" do
    it "creates the target directory if it does not exist" do
      subject.convert_all
      expect(FileUtils).to have_received(:mkdir_p).with(File.dirname(test_aif_file.sub(source_directory.to_s, target_directory.to_s))).twice
    end

    it "initializes the AudioConverter only for .aif and .flac files" do
      subject.convert_all
      expect(AudioProcessing::AudioConverter).to have_received(:new).with(
        output_directory: File.dirname(test_aif_file.sub(source_directory.to_s, target_directory.to_s))
      ).twice
    end

    it "calls convert on the AudioConverter for each .aif and .flac file" do
      subject.convert_all
      expect(converter).to have_received(:convert).with(file: test_aif_file.to_s).once
      expect(converter).to have_received(:convert).with(file: test_flac_file.to_s).once
    end

    it "does not process files that are not .aif or .flac" do
      subject.convert_all
      expect(converter).not_to have_received(:convert).with(file: unprocessed_file.to_s)
    end
  end
end
