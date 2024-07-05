class AudioTransfer < ApplicationRecord
  searchkick word_start: [:filename, :album_title, :recording_title, :transfer_agent_name, :audio_variants_filenames, :orchestra_name, :singer_names, :genre, :period, :composer_names, :lyricist_names]

  belongs_to :recording, dependent: :destroy
  belongs_to :album, dependent: :destroy
  belongs_to :transfer_agent
  belongs_to :audio_file
  has_many :audio_variants, dependent: :destroy
  has_one :waveform, dependent: :destroy

  def search_data
    {
      filename: audio_file.filename,
      album: album&.title,
      recording: recording&.title,
      transfer_agent: transfer_agent&.name,
      orchestra_name: recording&.orchestra&.name,
      singer_names: recording&.singers&.map(&:name)&.join(" "),
      genre: recording&.genre&.name,
      period: recording&.period&.name,
      composer_names: recording&.composition&.composer&.name,
      lyricist_names: recording&.composition&.lyricist&.name
    }
  end
end

# == Schema Information
#
# Table name: audio_transfers
#
#  id                :uuid             not null, primary key
#  external_id       :string
#  album_id          :uuid
#  transfer_agent_id :uuid
#  recording_id      :uuid
#  audio_file_id     :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
