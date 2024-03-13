class AudioTransfer < ApplicationRecord
  searchkick word_middle: [:filename, :album_title, :recording_title, :transfer_agent_name, :audio_variants_filenames, :orchestra_name, :singer_names, :genre, :period, :lyrics, :composer_names, :lyricist_names]

  belongs_to :transfer_agent, optional: true
  belongs_to :recording, optional: true
  belongs_to :album, optional: true, counter_cache: true
  has_many :audio_variants, dependent: :destroy
  has_one :waveform, dependent: :destroy

  validates :filename, presence: true, uniqueness: true

  has_one_attached :audio_file, dependent: :purge_later

  def self.search_audio_transfers(query)
    AudioTransfer.search(query,
      fields: [
        "filename",
        "album",
        "recording",
        "transfer_agent",
        "audio_variants",
        "waveform"
      ],
      match: :word_middle,
      misspellings: {below: 5},
      includes: [
        :album,
        :recording,
        :transfer_agent,
        :audio_variants
      ])
  end

  def search_data
    {
      filename:,
      album: album&.title,
      recording: recording&.title,
      transfer_agent: transfer_agent&.name,
      audio_variants: audio_variants.map(&:filename),
      orchestra_name: orchestra&.name,
      singer_names: singers.map(&:name).join(" "),
      genre: genre&.name,
      period: period&.name,
      lyrics: lyrics.map(&:content),
      composer_names: composition&.composer&.name,
      lyricist_names: composition&.lyricist&.name
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
#  album_id          :uuid
#  transfer_agent_id :uuid
#  recording_id      :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  filename          :string           not null
#
