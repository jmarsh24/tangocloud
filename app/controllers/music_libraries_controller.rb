class MusicLibrariesController < ApplicationController
  skip_after_action only: [:show]

  def show
    authorize :music_library, :show?

    @playlists = policy_scope(Playlist)
      .exclude_liked
      .public_playlists
      .excluding_mood_playlists
      .with_attached_image.limit(64)
    @singers = Person.joins(:recording_singers)
      .distinct
      .with_attached_image
      .order(recordings_count: :desc)
      .limit(64)
    @mood_playlists = policy_scope(Playlist)
      .exclude_liked
      .mood_playlists
      .random
      .with_attached_image.limit(64)
    @recordings = policy_scope(Recording)
      .random.strict_loading
      .includes(:composition, :orchestra, :singers, :genre,
        digital_remasters: [
          audio_variants: [
            audio_file_attachment: :blob
          ], album: [
            album_art_attachment: :blob
          ]
        ]).limit(128)
    @tandas = policy_scope(Tanda)
      .public_tandas
      .public_in_playlists
      .strict_loading
      .includes(
        :user,
        :tags,
        recordings: [
          :composition,
          :orchestra,
          :genre,
          :singers,
          digital_remasters: [
            audio_variants: [
              audio_file_attachment: :blob
            ],
            album: [
              album_art_attachment: :blob
            ]
          ]
        ]
      ).limit(64).random.with_attached_image
    @orchestras = policy_scope(Orchestra).ordered_by_recordings.with_attached_image

    @user_taggings = Tagging.where(user: current_user, taggable_type: "Tanda", taggable_id: @tandas.select(:id))
      .includes(:tag)
  end
end
