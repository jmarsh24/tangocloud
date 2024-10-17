class Lyric < ApplicationRecord
  has_one :composition_lyric, dependent: :destroy
  has_one :composition, through: :composition_lyric
  belongs_to :language

  validates :text, presence: true
end

# == Schema Information
#
# Table name: lyrics
#
#  id          :integer          not null, primary key
#  text        :text             not null
#  language_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
