module Recordings
  class LikesController < ApplicationController
    before_action :set_recording
    skip_after_action only: [:create, :destroy]

    def create
      authorize @recording, :like?

      @recording.likes.create!(user: current_user)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("like-button", partial: "players/like_button", locals: {recording: @recording, user: current_user})
        end
        format.html { redirect_to request.referer || root_path }
      end
    end

    def destroy
      authorize @recording, :unlike?

      @recording.likes.where(user: current_user).destroy_all

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("like-button", partial: "players/like_button", locals: {recording: @recording, user: current_user})
        end
        format.html { redirect_to request.referer || root_path }
      end
    end

    private

    def set_recording
      @recording = Recording.find(params[:recording_id])
    end
  end
end
