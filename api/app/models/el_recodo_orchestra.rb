class ElRecodoOrchestra < ApplicationRecord
  searchkick word_start: [:name], callbacks: :async

  validates :name, presence: true, uniqueness: true

  has_many :el_recodo_songs,
    dependent: :destroy,
    inverse_of: :el_recodo_orchestra

  has_many :el_recodo_person_roles,
    through: :el_recodo_songs,
    source: :el_recodo_person_roles

  has_many :el_recodo_people,
    through: :el_recodo_person_roles,
    source: :el_recodo_person,
    as: :members

  has_one_attached :image

  def search_data
    {
      name:
    }
  end
end

# == Schema Information
#
# Table name: el_recodo_orchestras
#
#  id         :uuid             not null, primary key
#  name       :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
