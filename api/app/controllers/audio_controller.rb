class AudiosController < ApplicationController
  before_action :set_audio, only: [:show]

  def show
    if @audio.file.attached?
      redirect_to rails_blob_url(@audio.file, disposition: "attachment", expires_in: 1.hour)
    else
      head :not_found
    end
  end

  private

  def set_audio
    @audio = Audio.find(params[:id])
  end
end
