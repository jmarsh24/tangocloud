# frozen_string_literal: true

# == Schema Information
#
# Table name: labels
#
#  id           :uuid             not null, primary key
#  name         :string           not null
#  description  :text
#  founded_date :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class RecordLabel < ApplicationRecord
  has_many :videos, dependent: :destroy

  validates :name, presence: true
end
