class User < ApplicationRecord
  searchkick word_start: [:username, :email, :first_name, :last_name]

  has_one :user_preference, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :playlists, dependent: :destroy
  has_many :playlist_items, through: :playlists
  has_many :listens, dependent: :destroy
  has_many :mood_tags, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :shared_recordings, through: :shares, source: :shareable, source_type: "Recording"
  has_many :shared_playlists, through: :shares, source: :shareable, source_type: "Playlist"
  has_many :shared_orchestras, through: :shares, source: :shareable, source_type: "Orchestra"
  has_many :sessions, dependent: :destroy
  has_many :events, dependent: :destroy

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  after_create :ensure_user_preference

  delegate :avatar, to: :user_preference, allow_nil: true
  delegate :first_name, :last_name, :name, to: :user_preference, allow_nil: true

  class << self
    def find_by_email_or_username(email_or_username)
      find_by(email: email_or_username) || find_by(username: email_or_username)
    end
  end

  def to_s
    name
  end

  def avatar_thumbnail(width: 160)
    if avatar&.attached?
      avatar.variant(:large)
    else
      Gravatar.new(email).url(width:)
    end
  end

  def search_data
    {
      username:,
      email:,
      first_name:,
      last_name:
    }
  end

  private

  def ensure_user_preference
    create_user_preference unless user_preference
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  password_digest :string
#  verified        :boolean          default(FALSE), not null
#  provider        :string
#  uid             :string
#  username        :string
#  admin           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
