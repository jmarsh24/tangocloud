class RecordingsController < ApplicationController
  before_action :redirect_crawlers, only: :show
  skip_before_action :authenticate_user!, only: [:meta_tags]
  skip_after_action :verify_authorized, :verify_policy_scoped, only: [:meta_tags]

  def show
    playback_queue = PlaybackQueue.find_or_create_by(user: current_user)
    playback_session = PlaybackSession.find_or_create_by(user: current_user)

    authorize @recording = policy_scope(Recording).with_associations.find(params[:id])

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue:, playback_session:})
      end
    end
  end

  def meta_tags
    @recording = Recording.with_associations.find(params[:id])

    render template: "recordings/meta_tags", layout: false
  end

  private

  def redirect_crawlers
    if /facebookexternalhit|Twitterbot|Pinterest|Slackbot|Googlebot/i.match?(request.user_agent)
      redirect_to meta_tags_recording_path(id: params[:id])
    end
  end
end
