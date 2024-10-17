require "rails_helper"

RSpec.describe TimePeriod, type: :model do
  describe ".covering_year" do
    let!(:time_period) { TimePeriod.create!(name: "2020s", start_year: 2020, end_year: 2029) }

    it "includes years within the range" do
      expect(TimePeriod.covering_year(2025)).to include(time_period)
    end

    it "excludes years outside the range" do
      expect(TimePeriod.covering_year(2030)).not_to include(time_period)
    end

    it "includes edge years" do
      expect(TimePeriod.covering_year(2020)).to include(time_period)
      expect(TimePeriod.covering_year(2029)).to include(time_period)
    end
  end
end

# == Schema Information
#
# Table name: time_periods
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  start_year  :integer          default(0), not null
#  end_year    :integer          default(0), not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
