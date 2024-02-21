class Playlist < ApplicationRecord
  validates :title, presence: true

  belongs_to :user
  has_many :playlist_audio_transfers, -> { order(position: :asc) }, dependent: :destroy
  has_many :audio_transfers, through: :playlist_audio_transfers
end

# == Schema Information
#
# Table name: playlists
#
#  id              :uuid             not null, primary key
#  title           :string           not null
#  description     :string
#  public          :boolean          default(TRUE), not null
#  songs_count     :integer          default(0), not null
#  likes_count     :integer          default(0), not null
#  listens_count   :integer          default(0), not null
#  shares_count    :integer          default(0), not null
#  followers_count :integer          default(0), not null
#  user_id         :uuid             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
