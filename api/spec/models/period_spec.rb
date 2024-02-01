require "rails_helper"

RSpec.describe Period, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: periods
#
#  id               :uuid             not null, primary key
#  name             :string           not null
#  description      :text
#  start_year       :integer          default(0), not null
#  end_year         :integer          default(0), not null
#  recordings_count :integer          default(0), not null
#  slug             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
