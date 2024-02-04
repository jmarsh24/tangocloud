class AudiosController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :set_audio, only: [:show]

  def show
    if @audio.file.attached?
      redirect_to @audio.file.url
    else
      render json: {error: "File not found"}, status: :not_found
    end
  end

  private

  def set_audio
    @audio = authorize Audio.find_signed(params[:id])
  end
end
