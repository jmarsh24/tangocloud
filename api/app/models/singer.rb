class Singer < ApplicationRecord
  extend FriendlyId
  include Titleizable
  friendly_id :name, use: :slugged
  searchkick word_start: [:first_name, :last_name, :name], callbacks: :async

  has_many :recording_singers, dependent: :destroy
  has_many :recordings, through: :recording_singers

  validates :first_name, presence: true
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :rank, presence: true, numericality: {only_integer: true}

  before_validation :assign_names, on: :create

  has_one_attached :photo

  def search_data
    {
      first_name:,
      last_name:,
      name:
    }
  end

  def assign_names
    if new_record?
      formatted_name = self.class.custom_titleize(name)
      names = formatted_name.split(" ")

      self.name = formatted_name
      self.first_name = names.first
      self.last_name = (names.length > 1) ? names.last : ""
      self.sort_name = (names.length > 1) ? names.last : ""
    end
  end
end

# == Schema Information
#
# Table name: singers
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  rank       :integer          default(0), not null
#  soloist    :boolean          default(FALSE), not null
#  sort_name  :string
#  bio        :text
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
