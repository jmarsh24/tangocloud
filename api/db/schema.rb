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

ActiveRecord::Schema[7.1].define(version: 2024_06_15_182709) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "btree_gist"
  enable_extension "citext"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "album_type", ["compilation", "original"]
  create_enum "recording_type", ["studio", "live"]
  create_enum "subscription_type", ["free", "premium", "hifi"]

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "albums", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.date "release_date"
    t.integer "audio_transfers_count", default: 0, null: false
    t.string "slug", null: false
    t.string "external_id"
    t.enum "album_type", default: "compilation", null: false, enum_type: "album_type"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["slug"], name: "index_albums_on_slug", unique: true
  end

  create_table "audio_transfers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "external_id"
    t.integer "position", default: 0, null: false
    t.uuid "album_id"
    t.uuid "transfer_agent_id"
    t.uuid "recording_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filename", null: false
    t.index ["album_id"], name: "index_audio_transfers_on_album_id"
    t.index ["filename"], name: "index_audio_transfers_on_filename", unique: true
    t.index ["recording_id"], name: "index_audio_transfers_on_recording_id"
    t.index ["transfer_agent_id"], name: "index_audio_transfers_on_transfer_agent_id"
  end

  create_table "audio_variants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "duration", default: 0, null: false
    t.string "format", null: false
    t.string "codec", null: false
    t.integer "bit_rate"
    t.integer "sample_rate"
    t.integer "channels"
    t.jsonb "metadata", default: {}, null: false
    t.uuid "audio_transfer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filename"
    t.index ["audio_transfer_id"], name: "index_audio_variants_on_audio_transfer_id"
    t.index ["filename"], name: "index_audio_variants_on_filename", unique: true
  end

  create_table "composers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.date "birth_date"
    t.date "death_date"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "compositions_count", default: 0
    t.string "normalized_name"
    t.index ["normalized_name"], name: "index_composers_on_normalized_name", unique: true
    t.index ["slug"], name: "index_composers_on_slug", unique: true
  end

  create_table "composition_composers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "composition_id", null: false
    t.uuid "composer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composer_id"], name: "index_composition_composers_on_composer_id"
    t.index ["composition_id"], name: "index_composition_composers_on_composition_id"
  end

  create_table "composition_lyrics", force: :cascade do |t|
    t.uuid "composition_id", null: false
    t.uuid "lyric_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composition_id"], name: "index_composition_lyrics_on_composition_id"
    t.index ["lyric_id"], name: "index_composition_lyrics_on_lyric_id"
  end

  create_table "compositions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "tangotube_slug"
    t.uuid "lyricist_id"
    t.uuid "composer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recordings_count", default: 0
    t.index ["composer_id"], name: "index_compositions_on_composer_id"
    t.index ["lyricist_id"], name: "index_compositions_on_lyricist_id"
  end

  create_table "couple_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "couple_id", null: false
    t.uuid "video_id", null: false
    t.index ["couple_id"], name: "index_couple_videos_on_couple_id"
    t.index ["video_id"], name: "index_couple_videos_on_video_id"
  end

  create_table "couples", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "dancer_id", null: false
    t.uuid "partner_id", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["dancer_id", "partner_id"], name: "index_couples_on_dancer_id_and_partner_id", unique: true
    t.index ["dancer_id"], name: "index_couples_on_dancer_id"
    t.index ["partner_id"], name: "index_couples_on_partner_id"
  end

  create_table "dancer_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "dancer_id", null: false
    t.uuid "video_id", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_dancer_videos_on_created_at"
    t.index ["dancer_id"], name: "index_dancer_videos_on_dancer_id"
    t.index ["updated_at"], name: "index_dancer_videos_on_updated_at"
    t.index ["video_id"], name: "index_dancer_videos_on_video_id"
  end

  create_table "dancers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "nickname"
    t.string "nationality"
    t.date "birth_date"
    t.date "death_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "el_recodo_songs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "action", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "friendly_id_slugs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "genres", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recordings_count", default: 0
  end

  create_table "likes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "likeable_type", null: false
    t.uuid "likeable_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
    t.index ["user_id", "likeable_type", "likeable_id"], name: "index_likes_on_user_id_and_likeable_type_and_likeable_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "lyricists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "sort_name"
    t.date "birth_date"
    t.date "death_date"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "compositions_count", default: 0
    t.string "normalized_name"
    t.index ["normalized_name"], name: "index_lyricists_on_normalized_name", unique: true
    t.index ["slug"], name: "index_lyricists_on_slug", unique: true
  end

  create_table "lyrics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "locale", null: false
    t.text "content", null: false
    t.uuid "composition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composition_id"], name: "index_lyrics_on_composition_id"
  end

  create_table "orchestras", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "rank", default: 0, null: false
    t.string "sort_name"
    t.date "birth_date"
    t.date "death_date"
    t.string "slug", null: false
    t.integer "recordings_count", default: 0
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "normalized_name"
    t.index ["normalized_name"], name: "index_orchestras_on_normalized_name", unique: true
    t.index ["slug"], name: "index_orchestras_on_slug", unique: true
  end

  create_table "periods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "playbacks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "recording_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recording_id"], name: "index_playbacks_on_recording_id"
    t.index ["user_id"], name: "index_playbacks_on_user_id"
  end

  create_table "playlist_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "playlist_id", null: false
    t.string "playable_type", null: false
    t.uuid "playable_id", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playable_type", "playable_id"], name: "index_playlist_items_on_playable"
    t.index ["playlist_id"], name: "index_playlist_items_on_playlist_id"
    t.index ["position"], name: "index_playlist_items_on_position"
  end

  create_table "playlists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.boolean "public", default: true, null: false
    t.integer "likes_count", default: 0, null: false
    t.integer "listens_count", default: 0, null: false
    t.integer "shares_count", default: 0, null: false
    t.integer "followers_count", default: 0, null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.boolean "system", default: false, null: false
    t.integer "playlist_items_count", default: 0
    t.index ["slug"], name: "index_playlists_on_slug", unique: true
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "record_labels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.date "founded_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recording_singers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "recording_id", null: false
    t.uuid "singer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recording_id"], name: "index_recording_singers_on_recording_id"
    t.index ["singer_id"], name: "index_recording_singers_on_singer_id"
  end

  create_table "recordings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.integer "bpm"
    t.date "release_date"
    t.date "recorded_date"
    t.string "slug", null: false
    t.enum "recording_type", default: "studio", null: false, enum_type: "recording_type"
    t.uuid "el_recodo_song_id"
    t.uuid "orchestra_id"
    t.uuid "singer_id"
    t.uuid "composition_id"
    t.uuid "record_label_id"
    t.uuid "genre_id"
    t.uuid "period_id"
    t.integer "playbacks_count", default: 0
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["composition_id"], name: "index_recordings_on_composition_id"
    t.index ["created_at"], name: "index_recordings_on_created_at"
    t.index ["el_recodo_song_id"], name: "index_recordings_on_el_recodo_song_id"
    t.index ["genre_id"], name: "index_recordings_on_genre_id"
    t.index ["orchestra_id"], name: "index_recordings_on_orchestra_id"
    t.index ["period_id"], name: "index_recordings_on_period_id"
    t.index ["record_label_id"], name: "index_recordings_on_record_label_id"
    t.index ["singer_id"], name: "index_recordings_on_singer_id"
    t.index ["slug"], name: "index_recordings_on_slug", unique: true
    t.index ["updated_at"], name: "index_recordings_on_updated_at"
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "singers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "rank", default: 0, null: false
    t.string "sort_name"
    t.text "bio"
    t.date "birth_date"
    t.date "death_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "soloist", default: false
    t.string "normalized_name"
    t.index ["normalized_name"], name: "index_singers_on_normalized_name", unique: true
    t.index ["slug"], name: "index_singers_on_slug", unique: true
  end

  create_table "solid_cache_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_solid_cache_entries_on_key", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.enum "subscription_type", default: "free", null: false, enum_type: "subscription_type"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "tanda_recordings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "position", default: 0, null: false
    t.uuid "tanda_id", null: false
    t.uuid "recording_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recording_id"], name: "index_tanda_recordings_on_recording_id"
    t.index ["tanda_id"], name: "index_tanda_recordings_on_tanda_id"
  end

  create_table "tandas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.boolean "public", default: true, null: false
    t.uuid "audio_transfer_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_transfer_id"], name: "index_tandas_on_audio_transfer_id"
    t.index ["user_id"], name: "index_tandas_on_user_id"
  end

  create_table "transfer_agents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_preferences", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.boolean "verified", default: false, null: false
    t.string "provider"
    t.string "uid"
    t.string "username"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "youtube_slug", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.uuid "recording_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recording_id"], name: "index_videos_on_recording_id"
  end

  create_table "waveforms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "audio_transfer_id", null: false
    t.integer "version", null: false
    t.integer "channels", null: false
    t.integer "sample_rate", null: false
    t.integer "samples_per_pixel", null: false
    t.integer "bits", null: false
    t.integer "length", null: false
    t.float "data", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_transfer_id"], name: "index_waveforms_on_audio_transfer_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audio_transfers", "albums"
  add_foreign_key "audio_transfers", "recordings"
  add_foreign_key "audio_transfers", "transfer_agents"
  add_foreign_key "audio_variants", "audio_transfers"
  add_foreign_key "composition_composers", "composers"
  add_foreign_key "composition_composers", "compositions"
  add_foreign_key "composition_lyrics", "compositions"
  add_foreign_key "composition_lyrics", "lyrics"
  add_foreign_key "compositions", "composers"
  add_foreign_key "compositions", "lyricists"
  add_foreign_key "couple_videos", "couples"
  add_foreign_key "couple_videos", "videos"
  add_foreign_key "couples", "dancers"
  add_foreign_key "couples", "dancers", column: "partner_id"
  add_foreign_key "dancer_videos", "dancers"
  add_foreign_key "dancer_videos", "videos"
  add_foreign_key "events", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "lyrics", "compositions"
  add_foreign_key "playbacks", "recordings"
  add_foreign_key "playbacks", "users"
  add_foreign_key "playlist_items", "playlists"
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
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "subscriptions", "users"
  add_foreign_key "tanda_recordings", "recordings"
  add_foreign_key "tanda_recordings", "tandas"
  add_foreign_key "tandas", "audio_transfers"
  add_foreign_key "user_preferences", "users"
  add_foreign_key "videos", "recordings"
  add_foreign_key "waveforms", "audio_transfers"
end
