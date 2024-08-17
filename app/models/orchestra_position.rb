# == Schema Information
#
# Table name: orchestra_positions
#
#  id                :uuid             not null, primary key
#  start_date        :date
#  end_date          :date
#  principal         :boolean          default(FALSE), not null
#  orchestra_id      :uuid             not null
#  orchestra_role_id :uuid             not null
#  person_id         :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class OrchestraPosition < ApplicationRecord
  belongs_to :orchestra
  belongs_to :orchestra_role
  belongs_to :person
end
