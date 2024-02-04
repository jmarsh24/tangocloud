require "rails_helper"

RSpec.describe "Audios", type: :request do
  describe "GET /audios/:id/file" do
    it "returns the audio file" do
      audio = audios(:volver_a_sonar_tango_tunes_1940)

      # get "/audios/#{audio.id}/file"

      # expect(response).to have_http_status(:ok)
      # expect(response.body).to eq(audio.file.download)
    end
  end
end
