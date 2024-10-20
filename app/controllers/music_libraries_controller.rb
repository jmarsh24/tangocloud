class MusicLibrariesController < ApplicationController
  skip_after_action :verify_policy_scoped, only: [:show]

  def show
    authorize :music_library, :show?

    @recordings = policy_scope(Recording).random.limit(36)
    @playlists = policy_scope(Playlist).limit(36).shuffle
    @tandas = policy_scope(Tanda).limit(36)
    @orchestras = policy_scope(Orchestra).ordered_by_recordings.limit(36)
  end
end
