class AudioTransfersController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_after_action :verify_authorized, only: [:new, :create]

  def new
  end

  def create
    @audio_transfer = AudioTransfer.new(audio_transfer_params)
    @audio_transfer.audio_file.attach(params[:signed_blob_id])

    if @audio_transfer.save

      render json: {
        audio_transfer: @audio_transfer,
        audio_url: url_for(@audio_transfer.audio_file)
      }, status: :created
    end
  end

  private

  def audio_transfer_params
    params.require(:audio_transfer).permit(:filename)
  end
end
