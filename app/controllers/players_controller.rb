class PlayersController < ApplicationController
  include RemoteModal
  allowed_remote_modal_actions :show
  force_frame_response :show

  def show
    @recording = policy_scope(Recording)
      .with_associations
      .includes(composition: {composition_lyrics: :lyric})
      .find(params[:recording_id])
    authorize @recording
  end
end
