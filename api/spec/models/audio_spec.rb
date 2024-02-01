# == Schema Information
#
# Table name: audios
#
#  id            :uuid             not null, primary key
#  bit_rate      :integer
#  sample_rate   :integer
#  channels      :integer
#  bit_depth     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  bit_rate_mode :string
#  codec         :string
#  length        :float
#  encoder       :string
#  metadata      :jsonb            not null
#
require "rails_helper"

RSpec.describe Audio, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
