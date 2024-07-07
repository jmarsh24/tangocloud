# == Schema Information
#
# Table name: orchestra_periods
#
#  id           :uuid             not null, primary key
#  name         :string
#  description  :text
#  start_date   :date
#  end_date     :date
#  orchestra_id :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class OrchestraPeriod < ApplicationRecord
  belongs_to :orchestra

  validates :orchestra, presence: true
end
