# frozen_string_literal: true

# == Schema Information
#
# Table name: composers
#
#  id         :uuid             not null, primary key
#  name       :string           default(""), not null
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Composer < ApplicationRecord
  has_many :compositions

  validates :name, presence: true
end
