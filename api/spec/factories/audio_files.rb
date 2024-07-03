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
    filename { "19401008__volver_a_sonar__roberto_rufino__tango.flac" }
    file { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/audio/19401008__volver_a_sonar__roberto_rufino__tango.flac"), "audio/flac") }
    status { "pending" }
  end
end
