class Genre < ApplicationRecord
  include FriendlyId
  friendly_id :name, use: :slugged
  searchkick word_start: [:name]
  has_many :recordings, dependent: :destroy

  validates :name, presence: true

  def search_data
    {
      name:
    }
  end
end

# == Schema Information
#
# Table name: genres
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
