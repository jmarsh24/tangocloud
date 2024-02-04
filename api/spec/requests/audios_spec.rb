require "rails_helper"

RSpec.describe "Audios", type: :request do
  describe "GET /audios/:id/file" do
    context "when user is not logged in" do
      it "returns 401 unauthorized" do
        audio = audios(:volver_a_sonar_tango_tunes_1940)
        get audio.signed_url

        expect(response).to have_http_status(401)
      end
    end

    context "when user is logged in" do
      it "redirects to audio file if user is authorized" do
        audio = audios(:volver_a_sonar_tango_tunes_1940)
        admin_user = users(:admin)

        user_token = AuthToken.token(admin_user)

        get audio.signed_url, headers: {Authorization: user_token}

        expect(response).to have_http_status 302

        follow_redirect!

        expect(response).to have_http_status 200
        expect(response.content_type).to eq("audio/flac")
        expect(response.body).to eq(audio.file.download)
        expect(response.headers["Content-Length"]).to eq(audio.file.byte_size.to_s)
        expect(response.headers["Content-Disposition"]).to eq("inline; filename=\"19401008_volver_a_sonar_roberto_rufino_tango_2476.flac\"; filename*=UTF-8''19401008_volver_a_sonar_roberto_rufino_tango_2476.flac")
      end

      it "returns 401 unauthorized if user is not authorized" do
        audio = audios(:volver_a_sonar_tango_tunes_1940)
        user = users(:normal)

        user_token = AuthToken.token(user)

        get audio.signed_url, headers: {Authorization: user_token}

        expect(response).to have_http_status(401)
      end
    end
  end
end
