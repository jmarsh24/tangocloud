class RecordLabel < ApplicationRecord
  has_many :recordings, dependent: :destroy

  validates :name, presence: true
end

# == Schema Information
#
# Table name: record_labels
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  description  :text
#  founded_date :date
#  bio          :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
