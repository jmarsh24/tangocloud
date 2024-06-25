class Orchestra < ApplicationRecord
  extend FriendlyId
  include Titleizable
  friendly_id :name, use: :slugged

  searchkick word_start: [:name, :sort_name], callbacks: :async

  has_many :recordings, dependent: :destroy
  has_many :shares, as: :shareable, dependent: :destroy
  has_many :time_periods, as: :timeable, dependent: :destroy

  validates :rank, presence: true, numericality: {only_integer: true}
  validates :slug, presence: true, uniqueness: true

  has_one_attached :photo

  def search_data
    {
      name:
    }
  end
end

# == Schema Information
#
# Table name: orchestras
#
#  id               :uuid             not null, primary key
#  name             :string           not null
#  rank             :integer          default(0), not null
#  sort_name        :string
#  birth_date       :date
#  death_date       :date
#  slug             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recordings_count :integer          default(0)
#
