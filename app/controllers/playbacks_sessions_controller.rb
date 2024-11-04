class PlaybackSessionsController < ApplicationController
  before_action :set_playback_session

  def play
    playback_session.update!(playing: true)
    head :ok
  end

  def pause
    playback_session.update!(playing: false)
    head :ok
  end

  private

  def set_playback_session
    playback_session = PlaybackSession.find_or_create_by(user: current_user)
  end
end
