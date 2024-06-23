class Composer < ApplicationRecord
  extend FriendlyId
  include Titleizable
  friendly_id :name, use: :slugged

  searchkick word_start: [:first_name, :last_name, :name], callbacks: :async

  has_many :compositions, dependent: :destroy
  has_many :recordings, through: :compositions

  validates :first_name, presence: true
  validates :slug, presence: true, uniqueness: true

  has_one_attached :photo

  before_create :assign_names

  def search_data
    {
      first_name:,
      last_name:,
      name:
    }
  end

  def assign_names
    formatted_name = self.class.custom_titleize(name)
    names = formatted_name.split(" ")
    self.name = formatted_name
    self.first_name = names.first
    self.last_name = (names.length > 1) ? names.last : ""
    self.sort_name = (names.length > 1) ? names.last : ""
  end
end

# == Schema Information
#
# Table name: composers
#
#  id                 :uuid             not null, primary key
#  first_name         :string           not null
#  last_name          :string
#  name               :string           not null
#  birth_date         :date
#  death_date         :date
#  sort_name          :string
#  slug               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  compositions_count :integer          default(0)
#
