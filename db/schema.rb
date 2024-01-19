# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_17_194927) do
  create_table "accounts", force: :cascade do |t|
  end

  create_table "album_audio_transfers", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "album_id", null: false
    t.string "audio_transfer_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_album_audio_transfers_on_album_id"
    t.index ["audio_transfer_id"], name: "index_album_audio_transfers_on_audio_transfer_id"
  end

  create_table "albums", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "title", default: "", null: false
    t.text "description"
    t.date "release_date"
    t.integer "type", default: 0, null: false
    t.integer "recordings_count", default: 0, null: false
    t.string "slug", default: "", null: false
    t.string "external_id"
    t.string "transfer_agent_id", null: false
    t.index ["slug"], name: "index_albums_on_slug"
    t.index ["transfer_agent_id"], name: "index_albums_on_transfer_agent_id"
  end

  create_table "audio_transfers", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "method", default: "", null: false
    t.string "external_id"
    t.date "recording_date"
    t.string "transfer_agent_id", null: false
    t.string "audio_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_id"], name: "index_audio_transfers_on_audio_id"
    t.index ["transfer_agent_id"], name: "index_audio_transfers_on_transfer_agent_id"
  end

  create_table "audios", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.integer "duration", default: 0, null: false
    t.string "format", default: "", null: false
    t.integer "bit_rate"
    t.integer "sample_rate"
    t.integer "channels"
    t.integer "bit_depth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "composers", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.date "birth_date"
    t.date "death_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "composition_composers", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "composition_id", null: false
    t.string "composer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composer_id"], name: "index_composition_composers_on_composer_id"
    t.index ["composition_id"], name: "index_composition_composers_on_composition_id"
  end

  create_table "compositions", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "title", default: "", null: false
    t.string "genre_id", null: false
    t.string "lyricist_id", null: false
    t.string "composer_id", null: false
    t.integer "listens_count"
    t.integer "popularity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composer_id"], name: "index_compositions_on_composer_id"
    t.index ["genre_id"], name: "index_compositions_on_genre_id"
    t.index ["lyricist_id"], name: "index_compositions_on_lyricist_id"
  end

  create_table "couple_videos", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "couple_id", null: false
    t.string "video_id", null: false
    t.index ["couple_id"], name: "index_couple_videos_on_couple_id"
    t.index ["video_id"], name: "index_couple_videos_on_video_id"
  end

  create_table "couples", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.integer "dancer_id", null: false
    t.integer "partner_id", null: false
    t.index ["dancer_id", "partner_id"], name: "index_couples_on_dancer_id_and_partner_id", unique: true
    t.index ["dancer_id"], name: "index_couples_on_dancer_id"
    t.index ["partner_id"], name: "index_couples_on_partner_id"
  end

  create_table "dancer_videos", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "dancer_id", null: false
    t.string "video_id", null: false
    t.index ["dancer_id"], name: "index_dancer_videos_on_dancer_id"
    t.index ["video_id"], name: "index_dancer_videos_on_video_id"
  end

  create_table "dancers", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "nickname"
    t.string "nationality"
    t.date "birth_date"
    t.date "death_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "el_recodo_songs", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.date "date", null: false
    t.integer "ert_number", default: 0, null: false
    t.integer "music_id", default: 0, null: false
    t.string "title", null: false
    t.string "style"
    t.string "orchestra"
    t.string "singer"
    t.string "composer"
    t.string "author"
    t.string "label"
    t.text "lyrics"
    t.string "normalized_title"
    t.string "normalized_orchestra"
    t.string "normalized_singer"
    t.string "normalized_composer"
    t.string "normalized_author"
    t.string "search_data"
    t.datetime "synced_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "page_updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "recording_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_el_recodo_songs_on_date"
    t.index ["ert_number"], name: "index_el_recodo_songs_on_ert_number"
    t.index ["music_id"], name: "index_el_recodo_songs_on_music_id", unique: true
    t.index ["normalized_composer"], name: "index_el_recodo_songs_on_normalized_composer"
    t.index ["normalized_orchestra"], name: "index_el_recodo_songs_on_normalized_orchestra"
    t.index ["normalized_singer"], name: "index_el_recodo_songs_on_normalized_singer"
    t.index ["normalized_title"], name: "index_el_recodo_songs_on_normalized_title"
    t.index ["page_updated_at"], name: "index_el_recodo_songs_on_page_updated_at"
    t.index ["recording_id"], name: "index_el_recodo_songs_on_recording_id"
    t.index ["search_data"], name: "index_el_recodo_songs_on_search_data"
    t.index ["synced_at"], name: "index_el_recodo_songs_on_synced_at"
  end

  create_table "friendly_id_slugs", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "genres", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "labels", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.date "founded_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lyricists", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "sort_name"
    t.date "birth_date"
    t.date "death_date"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_lyricists_on_slug"
  end

  create_table "lyrics", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "locale", default: "", null: false
    t.text "content", default: "", null: false
    t.string "composition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composition_id"], name: "index_lyrics_on_composition_id"
  end

  create_table "orchestras", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "rank", default: 0, null: false
    t.string "sort_name"
    t.date "birth_date"
    t.date "death_date"
    t.string "slug", default: "", null: false
    t.index ["slug"], name: "index_orchestras_on_slug"
  end

  create_table "periods", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.integer "start_year", default: 0, null: false
    t.integer "end_year", default: 0, null: false
    t.integer "recordings_count", default: 0, null: false
    t.string "slug", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_periods_on_slug"
  end

  create_table "playlist_audio_transfers", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "playlist_id", null: false
    t.string "audio_transfer_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_transfer_id"], name: "index_playlist_audio_transfers_on_audio_transfer_id"
    t.index ["playlist_id"], name: "index_playlist_audio_transfers_on_playlist_id"
  end

  create_table "playlists", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "title", default: "", null: false
    t.string "description"
    t.boolean "public", default: true, null: false
    t.integer "songs_count", default: 0, null: false
    t.integer "likes_count", default: 0, null: false
    t.integer "listens_count", default: 0, null: false
    t.integer "shares_count", default: 0, null: false
    t.integer "followers_count", default: 0, null: false
    t.string "action_auth_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_auth_user_id"], name: "index_playlists_on_action_auth_user_id"
  end

  create_table "recording_singers", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "recording_id", null: false
    t.string "singer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recording_id"], name: "index_recording_singers_on_recording_id"
    t.index ["singer_id"], name: "index_recording_singers_on_singer_id"
  end

  create_table "recordings", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "title", default: "", null: false
    t.integer "bpm"
    t.integer "type", default: 0, null: false
    t.date "release_date"
    t.date "recorded_date"
    t.string "tangotube_slug"
    t.string "orchestra_id", null: false
    t.string "singer_id", null: false
    t.string "composition_id", null: false
    t.string "label_id", null: false
    t.string "genre_id", null: false
    t.string "period_id", null: false
    t.index ["composition_id"], name: "index_recordings_on_composition_id"
    t.index ["genre_id"], name: "index_recordings_on_genre_id"
    t.index ["label_id"], name: "index_recordings_on_label_id"
    t.index ["orchestra_id"], name: "index_recordings_on_orchestra_id"
    t.index ["period_id"], name: "index_recordings_on_period_id"
    t.index ["singer_id"], name: "index_recordings_on_singer_id"
  end

  create_table "sessions", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "singers", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.integer "rank", default: 0, null: false
    t.string "sort_name"
    t.text "bio"
    t.date "birth_date"
    t.date "death_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_singers_on_slug"
  end

  create_table "subscriptions", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description"
    t.integer "type", default: 0, null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.string "action_auth_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_auth_user_id"], name: "index_subscriptions_on_action_auth_user_id"
  end

  create_table "taggings", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tanda_audio_transfers", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.integer "position", default: 0, null: false
    t.string "tanda_id", null: false
    t.string "audio_transfer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_transfer_id"], name: "index_tanda_audio_transfers_on_audio_transfer_id"
    t.index ["tanda_id"], name: "index_tanda_audio_transfers_on_tanda_id"
  end

  create_table "tandas", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description"
    t.boolean "public", default: true, null: false
    t.string "audio_transfer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_transfer_id"], name: "index_tandas_on_audio_transfer_id"
  end

  create_table "transfer_agents", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_preferences", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "birth_date"
    t.string "locale", default: "en", null: false
    t.string "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
    t.index ["username"], name: "index_user_preferences_on_username", unique: true
  end

  create_table "user_settings", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.integer "user_id", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_settings_on_user_id"
  end

  create_table "users", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.string "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "videos", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "youtube_slug", default: "", null: false
    t.string "title", default: "", null: false
    t.string "description", default: "", null: false
    t.string "recording_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recording_id"], name: "index_videos_on_recording_id"
  end

  create_table "votes", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter"
  end

  add_foreign_key "album_audio_transfers", "albums"
  add_foreign_key "album_audio_transfers", "audio_transfers"
  add_foreign_key "albums", "transfer_agents"
  add_foreign_key "audio_transfers", "audios"
  add_foreign_key "audio_transfers", "transfer_agents"
  add_foreign_key "composition_composers", "composers"
  add_foreign_key "composition_composers", "compositions"
  add_foreign_key "compositions", "composers"
  add_foreign_key "compositions", "genres"
  add_foreign_key "compositions", "lyricists"
  add_foreign_key "couple_videos", "couples"
  add_foreign_key "couple_videos", "videos"
  add_foreign_key "couples", "dancers"
  add_foreign_key "couples", "dancers", column: "partner_id"
  add_foreign_key "dancer_videos", "dancers"
  add_foreign_key "dancer_videos", "videos"
  add_foreign_key "el_recodo_songs", "recordings"
  add_foreign_key "lyrics", "compositions"
  add_foreign_key "playlist_audio_transfers", "audio_transfers"
  add_foreign_key "playlist_audio_transfers", "playlists"
end
