class RecordLabel < ApplicationRecord
  has_many :recordings
  has_many :orchestras, through: :recordings
  has_many :singers, through: :recordings
  has_many :compositions, through: :recordings
  has_many :composers, through: :compositions
  has_many :lyricists, through: :compositions

  validates :name, presence: true
end

# == Schema Information
#
# Table name: record_labels
#
#  id           :uuid             not null, primary key
#  name         :string           not null
#  description  :text
#  founded_date :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
