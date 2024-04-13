class AudioVariantsController < ApplicationController
  include Rails.application.routes.url_helpers

  before_action :set_audio_variant, only: :show

  def show
    authorize @audio_variant

    redirect_to @audio_variant.audio_file.url
  end

  private

  def set_audio_variant
    authorize @audio_variant = AudioVariant.find(params[:id])
  end
end
