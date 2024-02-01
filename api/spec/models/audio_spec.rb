# == Schema Information
#
# Table name: audios
#
#  id                :uuid             not null, primary key
#  bit_rate          :integer
#  sample_rate       :integer
#  channels          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  codec             :string
#  length            :float
#  encoder           :string
#  metadata          :jsonb            not null
#  format            :string
#  bitrate           :integer
#  audio_transfer_id :uuid
#
require "rails_helper"

RSpec.describe Audio, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
