class AudioVariantsController < ApplicationController
  include Rails.application.routes.url_helpers

  before_action :set_audio_variant, only: :show
  skip_before_action :authenticate_user!
  # skip_after_action :verify_authorized, only: :show # this should be removed if you want to use the policy

  def show
    redirect_to url_for(@audio_variant.audio_file)
  end

  private

  def set_audio_variant
    @audio_variant = AudioVariant.find(params[:id])
  end
end
