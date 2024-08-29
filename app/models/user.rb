class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :trackable, :confirmable, :omniauthable

  searchkick word_start: [:username, :email, :first_name, :last_name]

  has_one :user_preference, dependent: :destroy
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

  after_create :ensure_user_preference

  delegate :avatar, to: :user_preference, allow_nil: true
  delegate :first_name, :last_name, :name, to: :user_preference, allow_nil: true

  accepts_nested_attributes_for :user_preference

  scope :search_import, -> { includes(:user_preference) }

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

  private

  def ensure_user_preference
    create_user_preference unless user_preference
  end

  def search_data
    {
      username:,
      email:,
      first_name:,
      last_name:
    }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  username               :string
#  admin                  :boolean          default(FALSE), not null
#  provider               :string
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#
