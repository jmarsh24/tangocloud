class AudiosController < ApplicationController
  before_action :set_audio, only: [:show]

  def show
    if @audio.file.attached?
      redirect_to @audio.file_url
    else
      render json: {error: "Audio file not found"}, status: :not_found
    end
  end

  private

  def set_audio
    @audio = authorize Audio.find_signed(params[:id])
  end
end
