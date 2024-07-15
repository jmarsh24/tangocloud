# == Schema Information
#
# Table name: audio_files
#
#  id            :uuid             not null, primary key
#  filename      :string           not null
#  format        :string           not null
#  status        :string           default("pending"), not null
#  error_message :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :audio_file do
    status { "pending" }
    filename { Faker::File.file_name }
    format { File.extname(filename).delete_prefix(".") }

    trait :flac do
      filename { "19401008__volver_a_sonar__roberto_rufino__tango.flac" }
      after(:build) do |audio_file|
        audio_file.file.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/audio/19401008__volver_a_sonar__roberto_rufino__tango.flac")),
          filename: "19401008__volver_a_sonar__roberto_rufino__tango.flac",
          content_type: "audio/flac"
        )
      end
    end

    trait :mp3 do
      filename { "19600715__a_los_amigos__instrumental__tango.mp3" }
      after(:build) do |audio_file|
        audio_file.file.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/audio/19600715__a_los_amigos__instrumental__tango.mp3")),
          filename: "19600715__a_los_amigos__instrumental__tango.mp3",
          content_type: "audio/mp3"
        )
      end
    end

    trait :orchestra do
      filename { "19401008__volver_a_sonar__roberto_rufino__tango.flac" }
      after(:build) do |audio_file|
        audio_file.file.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/audio/19401008__volver_a_sonar__roberto_rufino__tango.flac")),
          filename: "19401008__volver_a_sonar__roberto_rufino__tango.flac",
          content_type: "audio/flac"
        )
      end
    end

    trait :soloist do
      filename { "19581023__dicha_pasada__armando_cupo__tango.mp3" }
      after(:build) do |audio_file|
        audio_file.file.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/audio/19581023__dicha_pasada__armando_cupo__tango.mp3")),
          filename: "19581023__dicha_pasada__armando_cupo__tango.mp3",
          content_type: "audio/mp3"
        )
      end
    end

    trait :instrumental do
      filename { "19600715__a_los_amigos__instrumental__tango.mp3" }
      after(:build) do |audio_file|
        audio_file.file.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/audio/19600715__a_los_amigos__instrumental__tango.mp3")),
          filename: "19600715__a_los_amigos__instrumental__tango.mp3",
          content_type: "audio/mp3"
        )
      end
    end

    trait :singer do
      filename { "19800711__nunca_tuvo_novio__roberto_goyeneche__dir_osvaldo_berlingieri__tango.flac" }
      after(:build) do |audio_file|
        audio_file.file.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/audio/19800711__nunca_tuvo_novio__roberto_goyeneche__dir_osvaldo_berlingieri__tango.flac")),
          filename: "19800711__nunca_tuvo_novio__roberto_goyeneche__dir_osvaldo_berlingieri__tango.flac",
          content_type: "audio/flac"
        )
      end
    end

    trait :with_error do
      status { "error" }
      error_message { "An error occurred during processing." }
    end

    trait :processing do
      status { "processing" }
    end

    trait :completed do
      status { "completed" }
    end

    trait :failed do
      status { "failed" }
      error_message { "The file could not be processed." }
    end

    factory :flac_audio_file, traits: [:flac]
    factory :mp3_audio_file, traits: [:mp3]
    factory :orchestra_audio_file, traits: [:orchestra]
    factory :soloist_audio_file, traits: [:soloist]
    factory :instrumental_audio_file, traits: [:instrumental]
    factory :singer_audio_file, traits: [:singer]

    factory :orchestra_flac_audio_file, traits: [:orchestra, :flac]
    factory :orchestra_mp3_audio_file, traits: [:orchestra, :mp3]
    factory :soloist_flac_audio_file, traits: [:soloist, :flac]
    factory :soloist_mp3_audio_file, traits: [:soloist, :mp3]
    factory :instrumental_flac_audio_file, traits: [:instrumental, :flac]
    factory :instrumental_mp3_audio_file, traits: [:instrumental, :mp3]
    factory :singer_flac_audio_file, traits: [:singer, :flac]
    factory :singer_mp3_audio_file, traits: [:singer, :mp3]

    factory :processing_audio_file, traits: [:processing]
    factory :completed_audio_file, traits: [:completed]
    factory :failed_audio_file, traits: [:failed]
  end
end
