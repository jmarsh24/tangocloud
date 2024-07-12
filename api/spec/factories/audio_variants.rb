FactoryBot.define do
  factory :audio_variant do
    format { "mp3" }
    bit_rate { Faker::Number.between(from: 64000, to: 320000) }

    after(:build) do |audio_variant|
      audio_variant.audio_file.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/audio/compressed/19401008_volver_a_sonar_roberto_rufino_tango_2476.mp3")),
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
#  id                  :uuid             not null, primary key
#  format              :string           not null
#  bit_rate            :integer          default(0), not null
#  digital_remaster_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
