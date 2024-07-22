class ElRecodoOrchestra < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :el_recodo_songs, dependent: :destroy, foreign_key: :orchestra_id, inverse_of: :orchestra
  has_many :el_recodo_person_roles, through: :el_recodo_songs, source: :el_recodo_person_roles

  has_many :el_recodo_people, through: :el_recodo_person_roles, source: :el_recodo_person, as: :members

  has_one_attached :image
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
