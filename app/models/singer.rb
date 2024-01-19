# frozen_string_literal: true

# == Schema Information
#
# Table name: singers
#
#  id         :uuid             not null, primary key
#  name       :string           default(""), not null
#  slug       :string           default(""), not null
#  rank       :integer          default(0), not null
#  sort_name  :string
#  bio        :text
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Singer < ApplicationRecord
  extend FriendlyId
  has_many :recording_singers
  has_many :recordings, through: :recording_singers
  friendly_id :name, use: :slugged

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :rank, presence: true, numericality: {only_integer: true}
  validates :sort_name, presence: true
end
