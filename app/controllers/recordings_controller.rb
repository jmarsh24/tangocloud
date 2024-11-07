class RecordingsController < ApplicationController
  include RemoteModal
  allowed_remote_modal_actions :show
  force_frame_response :show
  def show
    @recording = policy_scope(Recording)
      .with_associations
      .includes(composition: {composition_lyrics: :lyric})
      .friendly.find(params[:id])
    authorize @recording
  end
end
