FactoryBot.define do
  factory :audio_variant do
    duration { Faker::Number.between(from: 60, to: 3600) }
    format { "mp3" }
    codec { "libmp3lame" }
    bit_rate { Faker::Number.between(from: 64000, to: 320000) }
    sample_rate { Faker::Number.between(from: 22050, to: 48000) }
    channels { [1, 2].sample }
    length { duration }
    metadata { {} }
    association :audio_transfer

    after(:build) do |audio_variant|
      audio_variant.audio_file.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/audio/19401008__volver_a_sonar__roberto_rufino__tango.mp3")),
        filename: "19401008__volver_a_sonar__roberto_rufino__tango.mp3",
        content_type: "audio/mpeg"
      )
    end
  end
end

# == Schema Information
#
# Table name: audio_variants
#
#  id                :uuid             not null, primary key
#  duration          :integer          default(0), not null
#  format            :string           not null
#  codec             :string           not null
#  bit_rate          :integer
#  sample_rate       :integer
#  channels          :integer
#  length            :integer          default(0), not null
#  metadata          :jsonb            not null
#  audio_transfer_id :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
