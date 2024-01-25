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

ActiveRecord::Schema[7.1].define(version: 2024_01_25_211408) do
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

  create_table "action_auth_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "action_auth_user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_auth_user_id"], name: "index_action_auth_sessions_on_action_auth_user_id"
  end

  create_table "action_auth_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.boolean "verified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "webauthn_id"
    t.index ["email"], name: "index_action_auth_users_on_email", unique: true
  end

  create_table "action_auth_webauthn_credentials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "external_id", null: false
    t.string "public_key", null: false
    t.string "nickname", null: false
    t.bigint "sign_count", default: 0, null: false
    t.uuid "action_auth_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_auth_user_id"], name: "index_action_auth_webauthn_credentials_on_action_auth_user_id"
    t.index ["external_id"], name: "index_action_auth_webauthn_credentials_on_external_id", unique: true
  end

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

  create_table "album_audio_transfers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "album_id", null: false
    t.uuid "audio_transfer_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_album_audio_transfers_on_album_id"
    t.index ["audio_transfer_id"], name: "index_album_audio_transfers_on_audio_transfer_id"
  end

  create_table "albums", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.date "release_date"
    t.integer "type", default: 0, null: false
    t.integer "recordings_count", default: 0, null: false
    t.string "slug", null: false
    t.string "external_id"
    t.uuid "transfer_agent_id"
    t.index ["slug"], name: "index_albums_on_slug"
    t.index ["title"], name: "index_albums_on_title", opclass: :gist_trgm_ops, using: :gist
    t.index ["transfer_agent_id"], name: "index_albums_on_transfer_agent_id"
  end

  create_table "audio_transfers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "method"
    t.string "external_id"
    t.date "recording_date"
    t.uuid "transfer_agent_id"
    t.uuid "audio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_id"], name: "index_audio_transfers_on_audio_id"
    t.index ["transfer_agent_id"], name: "index_audio_transfers_on_transfer_agent_id"
  end

  create_table "audios", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "bit_rate"
    t.integer "sample_rate"
    t.integer "channels"
    t.integer "bit_depth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bit_rate_mode"
    t.string "codec"
    t.float "length"
    t.string "encoder"
    t.jsonb "metadata", default: {}, null: false
  end

  create_table "composers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.date "birth_date"
    t.date "death_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "locale", null: false
    t.uuid "composition_id", null: false
    t.uuid "lyricist_id", null: false
    t.uuid "lyrics_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composition_id"], name: "index_composition_lyrics_on_composition_id"
    t.index ["lyricist_id"], name: "index_composition_lyrics_on_lyricist_id"
    t.index ["lyrics_id"], name: "index_composition_lyrics_on_lyrics_id"
  end

  create_table "compositions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "tangotube_slug"
    t.uuid "lyricist_id", null: false
    t.uuid "composer_id", null: false
    t.integer "listens_count"
    t.integer "popularity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["dancer_id", "partner_id"], name: "index_couples_on_dancer_id_and_partner_id", unique: true
    t.index ["dancer_id"], name: "index_couples_on_dancer_id"
    t.index ["partner_id"], name: "index_couples_on_partner_id"
  end

  create_table "dancer_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "dancer_id", null: false
    t.uuid "video_id", null: false
    t.index ["dancer_id"], name: "index_dancer_videos_on_dancer_id"
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
    t.string "soloist"
    t.string "director"
    t.string "normalized_soloist"
    t.string "normalized_director"
    t.index ["date"], name: "index_el_recodo_songs_on_date"
    t.index ["ert_number"], name: "index_el_recodo_songs_on_ert_number"
    t.index ["music_id"], name: "index_el_recodo_songs_on_music_id", unique: true
    t.index ["normalized_composer"], name: "index_el_recodo_songs_on_normalized_composer", opclass: :gist_trgm_ops, using: :gist
    t.index ["normalized_orchestra"], name: "index_el_recodo_songs_on_normalized_orchestra", opclass: :gist_trgm_ops, using: :gist
    t.index ["normalized_singer"], name: "index_el_recodo_songs_on_normalized_singer", opclass: :gist_trgm_ops, using: :gist
    t.index ["normalized_title"], name: "index_el_recodo_songs_on_normalized_title", opclass: :gist_trgm_ops, using: :gist
    t.index ["page_updated_at"], name: "index_el_recodo_songs_on_page_updated_at"
    t.index ["search_data"], name: "index_el_recodo_songs_on_search_data", opclass: :gist_trgm_ops, using: :gist
    t.index ["synced_at"], name: "index_el_recodo_songs_on_synced_at"
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
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "labels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.date "founded_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["slug"], name: "index_lyricists_on_slug"
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
    t.index ["slug"], name: "index_orchestras_on_slug"
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
    t.index ["slug"], name: "index_periods_on_slug"
  end

  create_table "playlist_audio_transfers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "playlist_id", null: false
    t.uuid "audio_transfer_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_transfer_id"], name: "index_playlist_audio_transfers_on_audio_transfer_id"
    t.index ["playlist_id"], name: "index_playlist_audio_transfers_on_playlist_id"
  end

  create_table "playlists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.boolean "public", default: true, null: false
    t.integer "songs_count", default: 0, null: false
    t.integer "likes_count", default: 0, null: false
    t.integer "listens_count", default: 0, null: false
    t.integer "shares_count", default: 0, null: false
    t.integer "followers_count", default: 0, null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
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
    t.integer "type", default: 0, null: false
    t.date "release_date"
    t.date "recorded_date"
    t.uuid "el_recodo_song_id"
    t.uuid "orchestra_id"
    t.uuid "singer_id"
    t.uuid "composition_id"
    t.uuid "label_id"
    t.uuid "genre_id"
    t.uuid "period_id"
    t.index ["composition_id"], name: "index_recordings_on_composition_id"
    t.index ["el_recodo_song_id"], name: "index_recordings_on_el_recodo_song_id"
    t.index ["genre_id"], name: "index_recordings_on_genre_id"
    t.index ["label_id"], name: "index_recordings_on_label_id"
    t.index ["orchestra_id"], name: "index_recordings_on_orchestra_id"
    t.index ["period_id"], name: "index_recordings_on_period_id"
    t.index ["singer_id"], name: "index_recordings_on_singer_id"
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
    t.index ["slug"], name: "index_singers_on_slug"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_solid_cache_entries_on_key", unique: true
  end

  create_table "subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.integer "type", default: 0, null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.uuid "action_auth_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_auth_user_id"], name: "index_subscriptions_on_action_auth_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
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

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tanda_audio_transfers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "position", default: 0, null: false
    t.uuid "tanda_id", null: false
    t.uuid "audio_transfer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_transfer_id"], name: "index_tanda_audio_transfers_on_audio_transfer_id"
    t.index ["tanda_id"], name: "index_tanda_audio_transfers_on_tanda_id"
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
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "birth_date"
    t.string "locale", default: "en", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
    t.index ["username"], name: "index_user_preferences_on_username", unique: true
  end

  create_table "user_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_settings_on_user_id"
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

  create_table "votes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "votable_type"
    t.bigint "votable_id"
    t.string "voter_type"
    t.bigint "voter_id"
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

  add_foreign_key "action_auth_sessions", "action_auth_users"
  add_foreign_key "action_auth_webauthn_credentials", "action_auth_users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "album_audio_transfers", "albums"
  add_foreign_key "album_audio_transfers", "audio_transfers"
  add_foreign_key "albums", "transfer_agents"
  add_foreign_key "audio_transfers", "audios"
  add_foreign_key "audio_transfers", "transfer_agents"
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
  add_foreign_key "lyrics", "compositions"
  add_foreign_key "playlist_audio_transfers", "audio_transfers"
  add_foreign_key "playlist_audio_transfers", "playlists"
  add_foreign_key "playlists", "action_auth_users", column: "user_id"
  add_foreign_key "recording_singers", "recordings"
  add_foreign_key "recording_singers", "singers"
  add_foreign_key "recordings", "compositions"
  add_foreign_key "recordings", "el_recodo_songs"
  add_foreign_key "recordings", "genres"
  add_foreign_key "recordings", "labels"
  add_foreign_key "recordings", "orchestras"
  add_foreign_key "recordings", "periods"
  add_foreign_key "recordings", "singers"
  add_foreign_key "subscriptions", "action_auth_users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tanda_audio_transfers", "audio_transfers"
  add_foreign_key "tanda_audio_transfers", "tandas"
  add_foreign_key "tandas", "action_auth_users", column: "user_id"
  add_foreign_key "tandas", "audio_transfers"
  add_foreign_key "user_preferences", "action_auth_users", column: "user_id"
  add_foreign_key "user_settings", "action_auth_users", column: "user_id"
  add_foreign_key "videos", "recordings"
end
