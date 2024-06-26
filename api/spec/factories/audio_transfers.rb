# == Schema Information
#
# Table name: audio_transfers
#
#  id                :uuid             not null, primary key
#  external_id       :string
#  position          :integer          default(0), not null
#  filename          :string           not null
#  album_id          :uuid
#  transfer_agent_id :uuid
#  recording_id      :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryBot.define do
  factory :audio_transfer do
    external_id { "MyString" }
    position { 1 }
    filename { "MyString" }
    album { nil }
    transfer_agent { nil }
    recording { nil }
  end
end
