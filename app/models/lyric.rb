class Lyric < ApplicationRecord
  has_many :composition_lyrics, dependent: :destroy
  has_many :compositions, through: :composition_lyrics
  belongs_to :language

  validates :text, presence: true
end

# == Schema Information
#
# Table name: lyrics
#
#  id          :uuid             not null, primary key
#  text        :text             not null
#  language_id :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
