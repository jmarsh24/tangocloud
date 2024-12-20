class RecordingsController < ApplicationController
  before_action :set_recording, only: :show
  skip_before_action :authenticate_user!, only: :show
  skip_after_action :verify_authorized, only: :show

  def index
    authorize Recording

    @recordings = if params[:query].present?
      Recording.search(params[:query], limit: 10)
    else
      Recording.all.limit(10)
    end

    tanda = Tanda.find_by(id: params[:tanda_id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "recording-results",
          partial: "recordings/results",
          locals: {recordings: @recordings, tanda:}
        )
      end
    end
  end

  def show
    return render template: "recordings/meta_tags", layout: false if crawler_request?

    authenticate_user! && return
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

  private

  def set_recording
    @recording = Recording.with_associations.find(params[:id])
  end

  def crawler_request?
    browser = Browser.new(request.user_agent)
    browser.bot?
  end
end
