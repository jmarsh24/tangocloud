# frozen_string_literal: true

# == Schema Information
#
# Table name: genres
#
#  id          :uuid             not null, primary key
#  name        :string           default(""), not null
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Genre < ApplicationRecord
  has_many :videos

  validates :name, presence: true

end
