class RecordingsController < ApplicationController
  before_action :set_recording, only: :show
  skip_before_action :authenticate_user!, only: :show
  skip_after_action :verify_authorized, only: :show

  def show
    if crawler_request?
      render template: "recordings/meta_tags", layout: false
    else
      authorize @recording

      playback_queue = PlaybackQueue.find_or_create_by(user: current_user)
      playback_session = PlaybackSession.find_or_create_by(user: current_user)

      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "music-player",
            partial: "shared/music_player",
            locals: {playback_queue:, playback_session:}
          )
        end
      end
    end
  end

  private

  def set_recording
    @recording = Recording.with_associations.find(params[:id])
  end

  def crawler_request?
    browser = Browser.new(request.user_agent)
    browser.bot?
  end
end
