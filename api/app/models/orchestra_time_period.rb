class OrchestraTimePeriod < ApplicationRecord
  belongs_to :orchestra
  belongs_to :time_period

  validates :start_date, presence: true
  validates :end_date, presence: true
end
