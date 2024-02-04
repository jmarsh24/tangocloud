class AudiosController < ApplicationController
  before_action :set_audio, only: [:show]

  def show
    audio = Audio.find(params[:id])
    signed_blob_id = audio.file.blob.signed_id(expires_in: ActiveStorage.urls_expire_in)
    filename = audio.file.blob.filename

    redirect_to rails_service_blob_proxy_path(
      :rails_blob_representation_proxy,
      signed_blob_id,
      filename:,
      host: ENV["CDN_HOST"]
    )
  end

  private

  def set_audio
    @audio = authorize Audio.find(params[:id])
  end
end
