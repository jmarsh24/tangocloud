# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id              :integer          not null, primary key
#  title           :string           not null
#  description     :string
#  public          :boolean          default(TRUE), not null
#  songs_count     :integer          default(0), not null
#  likes_count     :integer          default(0), not null
#  listens_count   :integer          default(0), not null
#  shares_count    :integer          default(0), not null
#  followers_count :integer          default(0), not null
#  user_id         :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Playlist < ApplicationRecord
  validates :title, presence: true
  validates :public, presence: true, inclusion: {in: [true, false]}
  validates :action_auth_user_id, presence: true
  validates :songs_count, presence: true, numericality: {only_integer: true}
  validates :likes_count, presence: true, numericality: {only_integer: true}
  validates :listens_count, presence: true, numericality: {only_integer: true}
  validates :shares_count, presence: true, numericality: {only_integer: true}
  validates :followers_count, presence: true, numericality: {only_integer: true}

  belongs_to :action_auth_user, class_name: "User"
  has_many :playlist_audio_transfers, dependent: :destroy
end
