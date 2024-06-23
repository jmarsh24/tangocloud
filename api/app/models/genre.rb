class Genre < ApplicationRecord
  searchkick word_middle: [:name]
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
#  id               :uuid             not null, primary key
#  name             :string           not null
#  description      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recordings_count :integer          default(0)
#
