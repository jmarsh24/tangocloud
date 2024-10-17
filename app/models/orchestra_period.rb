class OrchestraPeriod < ApplicationRecord
  belongs_to :orchestra
end

# == Schema Information
#
# Table name: orchestra_periods
#
#  id           :integer          not null, primary key
#  name         :string
#  description  :text
#  start_date   :date
#  end_date     :date
#  orchestra_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
