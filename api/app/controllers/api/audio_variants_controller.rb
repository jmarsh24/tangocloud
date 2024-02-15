module Api
  class AudioVariantsController < ApplicationController
    include ActiveStorage::SetCurrent
    before_action :set_audio_variant, only: [:show]

    def show
      if @audio_variant.audio.attached?
        redirect_to(@audio_variant.audio.url, allow_other_host: true)
      else
        render json: {error: "File not found"}, status: :not_found
      end
    end

    private

    def set_audio_variant
      @audio_variant = authorize AudioVariant.find_signed(params[:id])
    end
  end
end
