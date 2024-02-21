class AudioTransfersController < ApplicationController
  include Rails.application.routes.url_helpers

  def new
    authorize AudioTransfer
  end

  def create
    authorize AudioTransfer

    audio_transfer = AudioTransfer.new(audio_transfer_params)
    audio_transfer.audio_file.attach(params[:signed_blob_id])

    if audio_transfer.save
      AudioTransferImportJob.perform_later(audio_transfer)
      render json: {
        audio_transfer:,
        audio_url: url_for(audio_transfer.audio_file)
      }, status: :created
    else
      render json: {errors: audio_transfer.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def audio_transfer_params
    params.require(:audio_transfer).permit(:filename)
  end
end
