class AudioTransfer < ApplicationRecord
  searchkick word_middle: [:filename, :album_title, :recording_title, :transfer_agent_name, :audio_variants_filenames, :orchestra_name, :singer_names, :genre, :period, :composer_names, :lyricist_names]

  belongs_to :transfer_agent, optional: true
  belongs_to :recording, optional: true, dependent: :destroy
  belongs_to :album, optional: true, counter_cache: true, dependent: :destroy
  has_many :audio_variants, dependent: :delete_all
  has_one :waveform, dependent: :destroy

  validates :filename, presence: true, uniqueness: true

  has_one_attached :audio_file, dependent: :purge_later

  def search_data
    {
      filename:,
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
#  position          :integer          default(0), not null
#  filename          :string           not null
#  album_id          :uuid
#  transfer_agent_id :uuid
#  recording_id      :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
