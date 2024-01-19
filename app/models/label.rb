# frozen_string_literal: true

# == Schema Information
#
# Table name: labels
#
#  id           :uuid             not null, primary key
#  name         :string           default(""), not null
#  description  :text
#  founded_date :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Label < ApplicationRecord
  has_many :videos

  validates :name, presence: true

end
