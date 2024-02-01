# == Schema Information
#
# Table name: composition_composers
#
#  id             :uuid             not null, primary key
#  composition_id :uuid             not null
#  composer_id    :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class CompositionComposer < ApplicationRecord
  belongs_to :composition
  belongs_to :composer

  validates :composition_id, presence: true
  validates :composer_id, presence: true
  validates :composition_id, uniqueness: {scope: :composer_id}
end
