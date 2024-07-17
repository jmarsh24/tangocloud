class ElRecodoPerson < ApplicationRecord
  has_many :el_recodo_person_roles, dependent: :destroy
  has_many :el_recodo_songs, through: :el_recodo_person_roles
end

# == Schema Information
#
# Table name: el_recodo_people
#
#  id              :uuid             not null, primary key
#  birth_date      :date
#  death_date      :date
#  real_name       :string
#  nicknames       :string           is an Array
#  place_of_birth  :string
#  url             :string
#  image_url       :string
#  synced_at       :datetime         not null
#  page_updated_at :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
