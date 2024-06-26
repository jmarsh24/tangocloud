# == Schema Information
#
# Table name: audio_files
#
#  id                :uuid             not null, primary key
#  filename          :string           not null
#  status            :string           default("pending"), not null
#  error_message     :string
#  audio_transfer_id :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :audio_file do
    filename { "19401008_volver_a_sonar_roberto_rufino_tango_2476.flac" }
    file { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/19401008_volver_a_sonar_roberto_rufino_tango_2476.flac"), "audio/flac") }
    status { "pending" }
  end
end
