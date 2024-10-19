require "test_helper"

class Import::AudioFile::ImporterTest < ActiveSupport::TestCase
  def setup
    @directory_path = Rails.root.join("spec/fixtures/files/audio")
  end

  test "imports all audio files from the specified directory" do
    assert_enqueued_jobs 5, only: ::Import::AudioFile::CreateAudioFileJob do
      Import::AudioFile::Importer.new(@directory_path).sync
    end
  end

  test "skips files that are not supported" do
    AudioFile.create!(filename: "19390201__enrique_rodriguez__te_quiero_ver_escopeta__roberto_flores__tango__TC6612_TT.flac", format: "flac")

    assert_enqueued_jobs 4, only: ::Import::AudioFile::CreateAudioFileJob do
      Import::AudioFile::Importer.new(@directory_path).sync
    end
  end
end
