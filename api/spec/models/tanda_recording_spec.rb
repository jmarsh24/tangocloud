require "rails_helper"

RSpec.describe TandaRecoding, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: tanda_audio_transfers
#
#  id                :uuid             not null, primary key
#  position          :integer          default(0), not null
#  tanda_id          :uuid             not null
#  audio_transfer_id :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
