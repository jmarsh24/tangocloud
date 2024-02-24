class Composition < ApplicationRecord
  belongs_to :lyricist, optional: true
  belongs_to :composer, optional: true
  has_many :recordings, dependent: :destroy
  has_many :lyrics, dependent: :destroy

  validates :title, presence: true
end

# == Schema Information
#
# Table name: compositions
#
#  id               :uuid             not null, primary key
#  title            :string           not null
#  tangotube_slug   :string
#  lyricist_id      :uuid
#  composer_id      :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recordings_count :integer          default(0)
#
