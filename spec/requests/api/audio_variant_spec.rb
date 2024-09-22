require "rails_helper"

RSpec.describe Api::AudioVariantsController, type: :request do
  describe "GET /api/audio_variants/:id" do
    let(:audio_variant) { create(:audio_variant) }

    it "redirects to the audio file URL" do
      get api_audio_variant_path(audio_variant.id)
      expect(response).to have_http_status(:found)

      expect(response).to redirect_to(Rails.application.routes.url_helpers.rails_blob_path(audio_variant.audio_file))
    end

    it "returns 404 if the audio variant is not found" do
      get api_audio_variant_path("non-existent-id")

      expect(response).to have_http_status(:not_found)
    end
  end
end
