FactoryBot.define do
  factory :waveform do
    version { Faker::Number.between(from: 1, to: 3) }
    channels { Faker::Number.between(from: 1, to: 2) }
    sample_rate { Faker::Number.between(from: 22050, to: 48000) }
    samples_per_pixel { Faker::Number.between(from: 100, to: 1000) }
    bits { Faker::Number.between(from: 8, to: 32) }
    length { Faker::Number.between(from: 60, to: 3600) }
    data { Array.new(100) { Faker::Number.decimal(l_digits: 2, r_digits: 2) } }
    association :audio_transfer

    after(:build) do |waveform|
      waveform.image.attach(
        io: File.open(Rails.root.join("spec/support/assets/waveform.png")),
        filename: "waveform.png",
        content_type: "image/png"
      )
    end
  end
end
