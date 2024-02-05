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

ActiveRecord::Schema[7.1].define(version: 2024_02_05_170551) do
# Could not dump table "active_storage_attachments" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "active_storage_blobs" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "active_storage_variant_records" because of following StandardError
#   Unknown type 'uuid' for column 'id'

  create_table "albums", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.date "release_date"
    t.integer "audio_transfers_count", default: 0, null: false
    t.string "slug", null: false
    t.string "external_id"
    t.integer "album_type", default: 0, null: false
    t.index ["slug"], name: "index_albums_on_slug", unique: true
  end

  create_table "audio_transfers", force: :cascade do |t|
    t.string "external_id"
    t.integer "position", default: 0, null: false
    t.integer "album_id"
    t.integer "transfer_agent_id"
    t.integer "recording_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_audio_transfers_on_album_id"
    t.index ["recording_id"], name: "index_audio_transfers_on_recording_id"
    t.index ["transfer_agent_id"], name: "index_audio_transfers_on_transfer_agent_id"
  end

  create_table "audios", force: :cascade do |t|
    t.integer "duration", default: 0, null: false
    t.string "format", null: false
    t.string "codec", null: false
    t.integer "bit_rate"
    t.integer "sample_rate"
    t.integer "channels"
    t.integer "length", default: 0, null: false
    t.json "metadata", default: {}, null: false
    t.integer "audio_transfer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_transfer_id"], name: "index_audios_on_audio_transfer_id"
  end

  create_table "composers", force: :cascade do |t|
    t.string "name", null: false
    t.date "birth_date"
    t.date "death_date"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_composers_on_slug", unique: true
  end

  create_table "composition_composers", force: :cascade do |t|
    t.integer "composition_id", null: false
    t.integer "composer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composer_id"], name: "index_composition_composers_on_composer_id"
    t.index ["composition_id"], name: "index_composition_composers_on_composition_id"
  end

  create_table "composition_lyrics", force: :cascade do |t|
    t.string "locale", null: false
    t.integer "composition_id", null: false
    t.integer "lyricist_id", null: false
    t.integer "lyrics_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composition_id"], name: "index_composition_lyrics_on_composition_id"
    t.index ["lyricist_id"], name: "index_composition_lyrics_on_lyricist_id"
    t.index ["lyrics_id"], name: "index_composition_lyrics_on_lyrics_id"
  end

  create_table "compositions", force: :cascade do |t|
    t.string "title", null: false
    t.string "tangotube_slug"
    t.integer "lyricist_id"
    t.integer "composer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composer_id"], name: "index_compositions_on_composer_id"
    t.index ["lyricist_id"], name: "index_compositions_on_lyricist_id"
  end

  create_table "couple_videos", force: :cascade do |t|
    t.integer "couple_id", null: false
    t.integer "video_id", null: false
    t.index ["couple_id"], name: "index_couple_videos_on_couple_id"
    t.index ["video_id"], name: "index_couple_videos_on_video_id"
  end

  create_table "couples", force: :cascade do |t|
    t.integer "dancer_id", null: false
    t.integer "partner_id", null: false
    t.index ["dancer_id", "partner_id"], name: "index_couples_on_dancer_id_and_partner_id", unique: true
    t.index ["dancer_id"], name: "index_couples_on_dancer_id"
    t.index ["partner_id"], name: "index_couples_on_partner_id"
  end

  create_table "dancer_videos", force: :cascade do |t|
    t.integer "dancer_id", null: false
    t.integer "video_id", null: false
    t.index ["dancer_id"], name: "index_dancer_videos_on_dancer_id"
    t.index ["video_id"], name: "index_dancer_videos_on_video_id"
  end

  create_table "dancers", force: :cascade do |t|
    t.string "name", null: false
    t.string "nickname"
    t.string "nationality"
    t.date "birth_date"
    t.date "death_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "el_recodo_songs", force: :cascade do |t|
    t.date "date", null: false
    t.integer "ert_number", default: 0, null: false
    t.integer "music_id", default: 0, null: false
    t.string "title", null: false
    t.string "style"
    t.string "orchestra"
    t.string "singer"
    t.string "soloist"
    t.string "director"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_el_recodo_songs_on_date"
    t.index ["ert_number"], name: "index_el_recodo_songs_on_ert_number"
    t.index ["music_id"], name: "index_el_recodo_songs_on_music_id", unique: true
    t.index ["page_updated_at"], name: "index_el_recodo_songs_on_page_updated_at"
    t.index ["synced_at"], name: "index_el_recodo_songs_on_synced_at"
  end

  create_table "events", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "action", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "labels", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.date "founded_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lyricists", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "sort_name"
    t.date "birth_date"
    t.date "death_date"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_lyricists_on_slug", unique: true
  end

  create_table "lyrics", force: :cascade do |t|
    t.string "locale", null: false
    t.text "content", null: false
    t.integer "composition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composition_id"], name: "index_lyrics_on_composition_id"
    t.index ["locale", "composition_id"], name: "index_lyrics_on_locale_and_composition_id", unique: true
  end

  create_table "orchestras", force: :cascade do |t|
    t.string "name", null: false
    t.integer "rank", default: 0, null: false
    t.string "sort_name"
    t.date "birth_date"
    t.date "death_date"
    t.string "slug", null: false
    t.index ["slug"], name: "index_orchestras_on_slug", unique: true
  end

  create_table "periods", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "start_year", default: 0, null: false
    t.integer "end_year", default: 0, null: false
    t.integer "recordings_count", default: 0, null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_periods_on_slug", unique: true
  end

  create_table "playlist_audio_transfers", force: :cascade do |t|
    t.integer "playlist_id", null: false
    t.integer "audio_transfer_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_transfer_id"], name: "index_playlist_audio_transfers_on_audio_transfer_id"
    t.index ["playlist_id"], name: "index_playlist_audio_transfers_on_playlist_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.boolean "public", default: true, null: false
    t.integer "songs_count", default: 0, null: false
    t.integer "likes_count", default: 0, null: false
    t.integer "listens_count", default: 0, null: false
    t.integer "shares_count", default: 0, null: false
    t.integer "followers_count", default: 0, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "record_labels", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.date "founded_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recording_singers", force: :cascade do |t|
    t.integer "recording_id", null: false
    t.integer "singer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recording_id"], name: "index_recording_singers_on_recording_id"
    t.index ["singer_id"], name: "index_recording_singers_on_singer_id"
  end

  create_table "recordings", force: :cascade do |t|
    t.string "title", null: false
    t.integer "bpm"
    t.date "release_date"
    t.date "recorded_date"
    t.string "slug", null: false
    t.integer "recording_type", default: 0, null: false
    t.integer "el_recodo_song_id"
    t.integer "orchestra_id"
    t.integer "singer_id"
    t.integer "composition_id"
    t.integer "record_label_id"
    t.integer "genre_id"
    t.integer "period_id"
    t.index ["composition_id"], name: "index_recordings_on_composition_id"
    t.index ["el_recodo_song_id"], name: "index_recordings_on_el_recodo_song_id"
    t.index ["genre_id"], name: "index_recordings_on_genre_id"
    t.index ["orchestra_id"], name: "index_recordings_on_orchestra_id"
    t.index ["period_id"], name: "index_recordings_on_period_id"
    t.index ["record_label_id"], name: "index_recordings_on_record_label_id"
    t.index ["singer_id"], name: "index_recordings_on_singer_id"
    t.index ["slug"], name: "index_recordings_on_slug", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "singers", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "rank", default: 0, null: false
    t.string "sort_name"
    t.text "bio"
    t.date "birth_date"
    t.date "death_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_singers_on_slug", unique: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.integer "subscription_type", default: 0, null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "tanda_recordings", force: :cascade do |t|
    t.integer "position", default: 0, null: false
    t.integer "tanda_id", null: false
    t.integer "recording_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recording_id"], name: "index_tanda_recordings_on_recording_id"
    t.index ["tanda_id"], name: "index_tanda_recordings_on_tanda_id"
  end

  create_table "tandas", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.boolean "public", default: true, null: false
    t.integer "audio_transfer_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_transfer_id"], name: "index_tandas_on_audio_transfer_id"
    t.index ["user_id"], name: "index_tandas_on_user_id"
  end

  create_table "transfer_agents", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.string "provider"
    t.string "uid"
    t.string "username", null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "youtube_slug", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.integer "recording_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recording_id"], name: "index_videos_on_recording_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audio_transfers", "albums"
  add_foreign_key "audio_transfers", "recordings"
  add_foreign_key "audio_transfers", "transfer_agents"
  add_foreign_key "audios", "audio_transfers"
  add_foreign_key "composition_composers", "composers"
  add_foreign_key "composition_composers", "compositions"
  add_foreign_key "composition_lyrics", "compositions"
  add_foreign_key "composition_lyrics", "lyricists"
  add_foreign_key "composition_lyrics", "lyrics", column: "lyrics_id"
  add_foreign_key "compositions", "composers"
  add_foreign_key "compositions", "lyricists"
  add_foreign_key "couple_videos", "couples"
  add_foreign_key "couple_videos", "videos"
  add_foreign_key "couples", "dancers"
  add_foreign_key "couples", "dancers", column: "partner_id"
  add_foreign_key "dancer_videos", "dancers"
  add_foreign_key "dancer_videos", "videos"
  add_foreign_key "events", "users"
  add_foreign_key "lyrics", "compositions"
  add_foreign_key "playlist_audio_transfers", "audio_transfers"
  add_foreign_key "playlist_audio_transfers", "playlists"
  add_foreign_key "recording_singers", "recordings"
  add_foreign_key "recording_singers", "singers"
  add_foreign_key "recordings", "compositions"
  add_foreign_key "recordings", "el_recodo_songs"
  add_foreign_key "recordings", "genres"
  add_foreign_key "recordings", "orchestras"
  add_foreign_key "recordings", "periods"
  add_foreign_key "recordings", "record_labels"
  add_foreign_key "recordings", "singers"
  add_foreign_key "sessions", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "tanda_recordings", "recordings"
  add_foreign_key "tanda_recordings", "tandas"
  add_foreign_key "tandas", "audio_transfers"
  add_foreign_key "videos", "recordings"
end
