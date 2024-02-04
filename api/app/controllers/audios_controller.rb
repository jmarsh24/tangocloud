class AudiosController < ApplicationController
  before_action :set_audio, only: [:show]

  def show
    redirect_to @audio.file_url
  end

  private

  def set_audio
    @audio = authorize Audio.find_signed(params[:id])
  end
end
