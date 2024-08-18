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

ActiveRecord::Schema[7.1].define(version: 2024_08_18_223956) do
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
  create_enum "audio_file_status", ["pending", "processing", "completed", "failed"]
  create_enum "composition_role_type", ["composer", "lyricist"]
  create_enum "recording_type", ["studio", "live"]

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
    t.string "external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_albums_on_title", unique: true
  end

  create_table "audio_files", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "filename", null: false
    t.string "format", null: false
    t.string "status", default: "pending", null: false
    t.string "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filename"], name: "index_audio_files_on_filename", unique: true
  end

  create_table "audio_variants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "format", null: false
    t.integer "bit_rate", default: 0, null: false
    t.uuid "digital_remaster_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["digital_remaster_id"], name: "index_audio_variants_on_digital_remaster_id"
  end

  create_table "composition_lyrics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "composition_id", null: false
    t.uuid "lyric_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composition_id"], name: "index_composition_lyrics_on_composition_id"
    t.index ["lyric_id"], name: "index_composition_lyrics_on_lyric_id"
  end

  create_table "composition_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.enum "role", null: false, enum_type: "composition_role_type"
    t.uuid "person_id", null: false
    t.uuid "composition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composition_id"], name: "index_composition_roles_on_composition_id"
    t.index ["person_id"], name: "index_composition_roles_on_person_id"
    t.index ["role", "person_id", "composition_id"], name: "idx_on_role_person_id_composition_id_6ffdb3e22b", unique: true
  end

  create_table "compositions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "digital_remasters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "duration", default: 0, null: false
    t.integer "bpm"
    t.string "external_id"
    t.decimal "replay_gain", precision: 5, scale: 2
    t.decimal "peak_value", precision: 8, scale: 6
    t.integer "tango_cloud_id", null: false
    t.uuid "album_id", null: false
    t.uuid "remaster_agent_id"
    t.uuid "recording_id", null: false
    t.uuid "audio_file_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_digital_remasters_on_album_id"
    t.index ["audio_file_id"], name: "index_digital_remasters_on_audio_file_id"
    t.index ["external_id"], name: "index_digital_remasters_on_external_id", unique: true
    t.index ["recording_id"], name: "index_digital_remasters_on_recording_id"
    t.index ["remaster_agent_id"], name: "index_digital_remasters_on_remaster_agent_id"
    t.index ["tango_cloud_id"], name: "index_digital_remasters_on_tango_cloud_id", unique: true
  end

  create_table "external_catalog_el_recodo_empty_pages", force: :cascade do |t|
    t.integer "ert_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ert_number"], name: "index_external_catalog_el_recodo_empty_pages_on_ert_number", unique: true
  end

  create_table "external_catalog_el_recodo_orchestras", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "path", default: "", null: false
    t.index ["name"], name: "index_external_catalog_el_recodo_orchestras_on_name", unique: true
  end

  create_table "external_catalog_el_recodo_people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.date "birth_date"
    t.date "death_date"
    t.string "real_name"
    t.string "nicknames", array: true
    t.string "place_of_birth"
    t.string "path"
    t.datetime "synced_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_external_catalog_el_recodo_people_on_name", unique: true
  end

  create_table "external_catalog_el_recodo_person_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id", null: false
    t.uuid "song_id", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_external_catalog_el_recodo_person_roles_on_person_id"
    t.index ["song_id"], name: "index_external_catalog_el_recodo_person_roles_on_song_id"
  end

  create_table "external_catalog_el_recodo_songs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "date", null: false
    t.integer "ert_number", default: 0, null: false
    t.string "title", null: false
    t.string "formatted_title"
    t.string "style"
    t.string "label"
    t.boolean "instrumental", default: true, null: false
    t.text "lyrics"
    t.integer "lyrics_year"
    t.string "search_data"
    t.string "matrix"
    t.string "disk"
    t.integer "speed"
    t.integer "duration"
    t.datetime "synced_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "page_updated_at"
    t.uuid "orchestra_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "el_recodo_orchestra_id"
    t.index ["date"], name: "index_external_catalog_el_recodo_songs_on_date"
    t.index ["el_recodo_orchestra_id"], name: "idx_on_el_recodo_orchestra_id_bec9fe0da0"
    t.index ["ert_number"], name: "index_external_catalog_el_recodo_songs_on_ert_number", unique: true
    t.index ["orchestra_id"], name: "index_external_catalog_el_recodo_songs_on_orchestra_id"
    t.index ["page_updated_at"], name: "index_external_catalog_el_recodo_songs_on_page_updated_at"
    t.index ["synced_at"], name: "index_external_catalog_el_recodo_songs_on_synced_at"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "languages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_languages_on_code", unique: true
  end

  create_table "likes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "likeable_type", null: false
    t.uuid "likeable_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
    t.index ["user_id", "likeable_type", "likeable_id"], name: "index_likes_on_user_id_and_likeable_type_and_likeable_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "lyrics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text", null: false
    t.uuid "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_lyrics_on_language_id"
  end

  create_table "orchestra_periods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.uuid "orchestra_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["orchestra_id"], name: "index_orchestra_periods_on_orchestra_id"
  end

  create_table "orchestra_positions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.boolean "principal", default: false, null: false
    t.uuid "orchestra_id", null: false
    t.uuid "orchestra_role_id", null: false
    t.uuid "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["orchestra_id"], name: "index_orchestra_positions_on_orchestra_id"
    t.index ["orchestra_role_id"], name: "index_orchestra_positions_on_orchestra_role_id"
    t.index ["person_id"], name: "index_orchestra_positions_on_person_id"
  end

  create_table "orchestra_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_orchestra_roles_on_name", unique: true
  end

  create_table "orchestras", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "sort_name"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "el_recodo_orchestra_id"
    t.string "normalized_name"
    t.index ["el_recodo_orchestra_id"], name: "index_orchestras_on_el_recodo_orchestra_id"
    t.index ["name"], name: "index_orchestras_on_name", unique: true
    t.index ["normalized_name"], name: "index_orchestras_on_normalized_name", unique: true
    t.index ["slug"], name: "index_orchestras_on_slug", unique: true
    t.index ["sort_name"], name: "index_orchestras_on_sort_name"
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "sort_name"
    t.text "bio"
    t.date "birth_date"
    t.date "death_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.string "birth_place"
    t.uuid "el_recodo_person_id"
    t.string "normalized_name", null: false
    t.string "pseudonym"
    t.index ["el_recodo_person_id"], name: "index_people_on_el_recodo_person_id"
    t.index ["name"], name: "index_people_on_name"
    t.index ["normalized_name"], name: "index_people_on_normalized_name", unique: true
    t.index ["slug"], name: "index_people_on_slug", unique: true
    t.index ["sort_name"], name: "index_people_on_sort_name"
  end

  create_table "playbacks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "duration", default: 0, null: false
    t.uuid "user_id", null: false
    t.uuid "recording_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recording_id"], name: "index_playbacks_on_recording_id"
    t.index ["user_id"], name: "index_playbacks_on_user_id"
  end

  create_table "playlist_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "playlist_id", null: false
    t.string "item_type", null: false
    t.uuid "item_id", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_type", "item_id"], name: "index_playlist_items_on_item"
    t.index ["playlist_id"], name: "index_playlist_items_on_playlist_id"
    t.index ["position"], name: "index_playlist_items_on_position"
  end

  create_table "playlists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle"
    t.text "description"
    t.string "slug"
    t.boolean "public", default: true, null: false
    t.boolean "system", default: false, null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_playlists_on_slug", unique: true
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "record_labels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.date "founded_date"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_record_labels_on_name", unique: true
  end

  create_table "recording_singers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "recording_id", null: false
    t.uuid "person_id", null: false
    t.boolean "soloist", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_recording_singers_on_person_id"
    t.index ["recording_id"], name: "index_recording_singers_on_recording_id"
  end

  create_table "recordings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "recorded_date"
    t.string "slug", null: false
    t.enum "recording_type", default: "studio", null: false, enum_type: "recording_type"
    t.integer "playbacks_count", default: 0, null: false
    t.uuid "el_recodo_song_id"
    t.uuid "orchestra_id"
    t.uuid "composition_id", null: false
    t.uuid "genre_id", null: false
    t.uuid "record_label_id"
    t.uuid "time_period_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composition_id"], name: "index_recordings_on_composition_id"
    t.index ["el_recodo_song_id"], name: "index_recordings_on_el_recodo_song_id"
    t.index ["genre_id"], name: "index_recordings_on_genre_id"
    t.index ["orchestra_id"], name: "index_recordings_on_orchestra_id"
    t.index ["record_label_id"], name: "index_recordings_on_record_label_id"
    t.index ["slug"], name: "index_recordings_on_slug", unique: true
    t.index ["time_period_id"], name: "index_recordings_on_time_period_id"
  end

  create_table "remaster_agents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_remaster_agents_on_name", unique: true
  end

  create_table "shares", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "shareable_type", null: false
    t.uuid "shareable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shareable_type", "shareable_id"], name: "index_shares_on_shareable"
    t.index ["user_id", "shareable_type", "shareable_id"], name: "index_shares_on_user_id_and_shareable_type_and_shareable_id", unique: true
    t.index ["user_id"], name: "index_shares_on_user_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
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

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.string "key", null: false
    t.string "schedule", null: false
    t.string "command", limit: 2048
    t.string "class_name"
    t.text "arguments"
    t.string "queue_name"
    t.integer "priority", default: 0
    t.boolean "static", default: true
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
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

  create_table "taggings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tag_id", null: false
    t.string "taggable_type", null: false
    t.uuid "taggable_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id", "taggable_type", "taggable_id"], name: "index_taggings_on_tag_and_taggable", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["user_id"], name: "index_taggings_on_user_id"
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tanda_recordings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "position", default: 0, null: false
    t.uuid "tanda_id", null: false
    t.uuid "recording_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_tanda_recordings_on_position"
    t.index ["recording_id"], name: "index_tanda_recordings_on_recording_id"
    t.index ["tanda_id"], name: "index_tanda_recordings_on_tanda_id"
  end

  create_table "tandas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle"
    t.string "description"
    t.boolean "public", default: true, null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tandas_on_user_id"
  end

  create_table "time_periods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "start_year", default: 0, null: false
    t.integer "end_year", default: 0, null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_time_periods_on_name", unique: true
    t.index ["slug"], name: "index_time_periods_on_slug", unique: true
  end

  create_table "user_preferences", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username"
    t.boolean "admin", default: false, null: false
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "waveforms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "version", null: false
    t.integer "channels", null: false
    t.integer "sample_rate", null: false
    t.integer "samples_per_pixel", null: false
    t.integer "bits", null: false
    t.integer "length", null: false
    t.float "data", default: [], array: true
    t.uuid "digital_remaster_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["digital_remaster_id"], name: "index_waveforms_on_digital_remaster_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audio_variants", "digital_remasters"
  add_foreign_key "composition_lyrics", "compositions"
  add_foreign_key "composition_lyrics", "lyrics"
  add_foreign_key "composition_roles", "compositions"
  add_foreign_key "composition_roles", "people"
  add_foreign_key "digital_remasters", "albums"
  add_foreign_key "digital_remasters", "audio_files"
  add_foreign_key "digital_remasters", "recordings"
  add_foreign_key "digital_remasters", "remaster_agents"
  add_foreign_key "external_catalog_el_recodo_person_roles", "external_catalog_el_recodo_people", column: "person_id"
  add_foreign_key "external_catalog_el_recodo_person_roles", "external_catalog_el_recodo_songs", column: "song_id"
  add_foreign_key "external_catalog_el_recodo_songs", "external_catalog_el_recodo_orchestras", column: "el_recodo_orchestra_id"
  add_foreign_key "external_catalog_el_recodo_songs", "external_catalog_el_recodo_orchestras", column: "orchestra_id"
  add_foreign_key "likes", "users"
  add_foreign_key "lyrics", "languages"
  add_foreign_key "orchestra_periods", "orchestras"
  add_foreign_key "orchestra_positions", "orchestra_roles"
  add_foreign_key "orchestra_positions", "orchestras"
  add_foreign_key "orchestra_positions", "people"
  add_foreign_key "orchestras", "external_catalog_el_recodo_orchestras", column: "el_recodo_orchestra_id"
  add_foreign_key "people", "external_catalog_el_recodo_people", column: "el_recodo_person_id"
  add_foreign_key "playbacks", "recordings"
  add_foreign_key "playbacks", "users"
  add_foreign_key "playlist_items", "playlists"
  add_foreign_key "recording_singers", "people"
  add_foreign_key "recording_singers", "recordings"
  add_foreign_key "recordings", "compositions"
  add_foreign_key "recordings", "external_catalog_el_recodo_songs", column: "el_recodo_song_id"
  add_foreign_key "recordings", "genres"
  add_foreign_key "recordings", "orchestras"
  add_foreign_key "recordings", "record_labels"
  add_foreign_key "recordings", "time_periods"
  add_foreign_key "shares", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "users"
  add_foreign_key "tanda_recordings", "recordings"
  add_foreign_key "tanda_recordings", "tandas"
  add_foreign_key "user_preferences", "users"
  add_foreign_key "waveforms", "digital_remasters"
end
