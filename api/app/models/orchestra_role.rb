# == Schema Information
#
# Table name: orchestra_roles
#
#  id           :uuid             not null, primary key
#  start_date   :date
#  end_date     :date
#  principal    :boolean          default(FALSE), not null
#  orchestra_id :uuid             not null
#  role_id      :uuid             not null
#  person_id    :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class OrchestraRole < ApplicationRecord
  belongs_to :orchestra
  belongs_to :role
  belongs_to :person

  validates :orchestra, presence: true
  validates :role, presence: true
  validates :person, presence: true
end
