FactoryBot.define do
  factory :audio_variant do
    duration { Faker::Number.between(from: 60, to: 3600) }
    format { "mp3" }
    codec { "libmp3lame" }
    sequence(:filename) { |n| "audio_variant_#{n}.mp3" }
    bit_rate { Faker::Number.between(from: 64000, to: 320000) }
    sample_rate { Faker::Number.between(from: 22050, to: 48000) }
    channels { [1, 2].sample }
    length { duration }
    metadata { {} }
    association :audio_transfer

    after(:build) do |audio_variant|
      audio_variant.audio_file.attach(
        io: File.open(Rails.root.join("spec/support/assets/19421009_no_te_apures_carablanca_juan_carlos_miranda_tango_1918.m4a")),
        filename: "audio.mp3",
        content_type: "audio/mpeg"
      )
    end
  end
end
