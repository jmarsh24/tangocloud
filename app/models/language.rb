class Language < ApplicationRecord
  has_many :lyrics, dependent: :destroy

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end

# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
