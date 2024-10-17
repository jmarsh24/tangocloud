class OrchestraPosition < ApplicationRecord
  belongs_to :orchestra
  belongs_to :orchestra_role
  belongs_to :person
end

# == Schema Information
#
# Table name: orchestra_positions
#
#  id                :integer          not null, primary key
#  start_date        :date
#  end_date          :date
#  principal         :boolean          default(FALSE), not null
#  orchestra_id      :integer          not null
#  orchestra_role_id :integer          not null
#  person_id         :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
