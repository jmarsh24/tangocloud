class User < ApplicationRecord
  include Authenticatable

  searchkick word_start: [:email]

  has_many :likes, dependent: :destroy
  has_many :liked_recordings, -> { joins(:likes).order("likes.created_at DESC") }, through: :likes, source: :likeable, source_type: "Recording"
  has_many :tandas, dependent: :destroy
  has_many :playlists, dependent: :destroy
  has_many :playlist_items, through: :playlists
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :shares, dependent: :destroy
  has_many :shared_recordings, through: :shares, source: :shareable, source_type: "Recording"
  has_many :shared_playlists, through: :shares, source: :shareable, source_type: "Playlist"
  has_many :shared_orchestras, through: :shares, source: :shareable, source_type: "Orchestra"
  has_many :shared_tandas, through: :shares, source: :shareable, source_type: "Tanda"
  has_many :playbacks, dependent: :destroy

  has_one_attached :avatar

  def avatar_thumbnail(width: 160)
    if avatar&.attached?
      avatar.variant(:large)
    else
      Gravatar.new(email).url(width:)
    end
  end

  def approved?
    approved_at.present?
  end

  private

  def search_data
    {
      email:
    }
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  provider        :string
#  uid             :string
#  admin           :boolean          default(FALSE), not null
#  verified        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approved_at     :datetime
#
