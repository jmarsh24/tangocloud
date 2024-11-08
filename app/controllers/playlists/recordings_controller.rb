class Playlists::RecordingsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :load

  def load
    recording = Recording.find(params[:id])
    playlist = Playlist.find(params[:playlist_id])
    authorize playlist, :load?
    authorize recording, :load?

    playback_queue = PlaybackQueue.find_or_create_by(user: current_user)
    playback_session = PlaybackSession.find_or_create_by(user: current_user)
    playback_queue.load_playlist(playlist, start_with: recording)

    playback_session.play(reset_position: true)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue:, playback_session:})
        ]
      end
    end
  end
end
