module Recordings
  class LikesController < ApplicationController
    before_action :set_recording
    before_action :set_playback_session
    skip_after_action :verify_policy_scoped, only: [:create, :destroy]

    def create
      authorize @recording, :like?

      @recording.likes.create!(user: current_user)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("player", partial: "players/player", locals: {recording: @recording, playback_session: @playback_session}, method: "morph")
        end
        format.html { redirect_to request.referer || root_path }
      end
    end

    def destroy
      authorize @recording, :unlike?

      @recording.likes.where(user: current_user).destroy_all

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("player", partial: "players/player", locals: {recording: @recording, playback_session: @playback_session}, method: "morph")
        end
        format.html { redirect_to request.referer || root_path }
      end
    end

    private

    def set_recording
      @recording = Recording.find(params[:recording_id])
    end

    def set_playback_session
      @playback_session = PlaybackSession.find_by(user: current_user)
    end
  end
end
