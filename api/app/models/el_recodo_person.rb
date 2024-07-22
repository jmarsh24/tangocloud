class ElRecodoPerson < ApplicationRecord
  searchkick word_start: [:name, :real_name, :nicknames, :place_of_birth], callbacks: :async

  has_many :el_recodo_person_roles, dependent: :destroy
  has_many :el_recodo_songs, through: :el_recodo_person_roles

  has_one_attached :image

  validates :name, presence: true

  def search_data
    {
      name:,
      real_name:,
      nicknames:,
      place_of_birth:
    }
  end
end

# == Schema Information
#
# Table name: el_recodo_people
#
#  id             :uuid             not null, primary key
#  name           :string           default(""), not null
#  birth_date     :date
#  death_date     :date
#  real_name      :string
#  nicknames      :string           is an Array
#  place_of_birth :string
#  path           :string
#  synced_at      :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
