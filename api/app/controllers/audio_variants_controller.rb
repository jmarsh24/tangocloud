class AudioVariantsController < ApplicationController
  include Rails.application.routes.url_helpers

  before_action :set_audio_variant, only: :show

  def show
    redirect_to url_for(@audio_variant.audio_file)
  end

  private

  def set_audio_variant
    @audio_variant = AudioVariant.find(params[:id])
  end
end
