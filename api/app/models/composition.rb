# == Schema Information
#
# Table name: compositions
#
#  id             :uuid             not null, primary key
#  title          :string           not null
#  tangotube_slug :string
#  lyricist_id    :uuid             not null
#  composer_id    :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Composition < ApplicationRecord
  belongs_to :lyricist
  belongs_to :composer
  has_many :lyrics, dependent: :destroy

  validates :title, presence: true
end
