class PlayersController < ApplicationController
  def create
    @recording = policy_scope(Recording).find(params[:recording_id])

    authorize @recording, :play?

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("music-player", partial: "shared/music_player", locals: {recording: @recording})
      end
    end
  end
end
