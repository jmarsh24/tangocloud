class AudioTransfersController < ApplicationController
  include Rails.application.routes.url_helpers

  def new
    authorize AudioTransfer
  end

  def create
    authorize AudioTransfer

    digital_remaster = AudioTransfer.new(digital_remaster_params)
    digital_remaster.audio_file.attach(params[:signed_blob_id])

    if digital_remaster.save
      AudioTransferImportJob.perform_later(digital_remaster)
      render json: {
        digital_remaster:,
        audio_url: url_for(digital_remaster.audio_file)
      }, status: :created
    else
      render json: {errors: digital_remaster.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def digital_remaster_params
    params.require(:digital_remaster).permit(:filename)
  end
end
