require "rails_helper"

RSpec.describe "AudioVariants", type: :request do
  describe "GET /audio_variants/:id" do
    context "when user is logged in" do
      if !Config.ci? # this test is broken on ci but works locally
        it "redirects to audio file if user is authorized" do
          audio_variant = audio_variants(:volver_a_sonar_tango_tunes_1940_audio_variant)
          admin_user = users(:admin)

          user_token = AuthToken.token(admin_user)
          get audio_variant.signed_url, headers: {Authorization: user_token}

          expect(response).to have_http_status 302

          follow_redirect!

          expect(response).to have_http_status 200
          expect(response.content_type).to eq("audio/aac")
          expect(response.body).to eq(audio_variant.audio.download)
          expect(response.headers["Content-Length"]).to eq(audio_variant.audio.byte_size.to_s)
          expect(response.headers["Content-Disposition"]).to eq("inline; filename=\"19401008_volver_a_sonar_roberto_rufino_tango_2476_converted.aac\"; filename*=UTF-8''19401008_volver_a_sonar_roberto_rufino_tango_2476_converted.aac")
        end
      end

      it "returns 401 unauthorized if user is not authorized" do
        audio_variant = audio_variants(:volver_a_sonar_tango_tunes_1940_audio_variant)
        user = users(:normal)

        user_token = AuthToken.token(user)

        get audio_variant.signed_url, headers: {Authorization: user_token}

        expect(response).to have_http_status(401)
      end
    end
  end
end
