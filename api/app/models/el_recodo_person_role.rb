class ElRecodoPersonRole < ApplicationRecord
  belongs_to :el_recodo_person
  belongs_to :role
end

# == Schema Information
#
# Table name: el_recodo_person_roles
#
#  id                  :uuid             not null, primary key
#  el_recodo_person_id :uuid             not null
#  el_recodo_song_id   :uuid             not null
#  role                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
