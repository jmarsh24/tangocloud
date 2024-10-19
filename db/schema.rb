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

ActiveRecord::Schema[8.0].define(version: 2024_10_19_175336) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

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

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "action", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "external_catalog_el_recodo_empty_pages", force: :cascade do |t|
    t.integer "ert_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ert_number"], name: "index_external_catalog_el_recodo_empty_pages_on_ert_number", unique: true
  end

  create_table "external_catalog_el_recodo_orchestras", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "path", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.uuid "el_recodo_orchestra_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "normalized_name", default: "", null: false
    t.uuid "el_recodo_orchestra_id"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["el_recodo_orchestra_id"], name: "index_orchestras_on_el_recodo_orchestra_id"
    t.index ["name"], name: "index_orchestras_on_name", unique: true
    t.index ["normalized_name"], name: "index_orchestras_on_normalized_name", unique: true
    t.index ["slug"], name: "index_orchestras_on_slug", unique: true
    t.index ["sort_name"], name: "index_orchestras_on_sort_name"
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "slug"
    t.string "sort_name"
    t.string "nickname"
    t.string "birth_place"
    t.string "normalized_name", default: "", null: false
    t.string "pseudonym"
    t.text "bio"
    t.date "birth_date"
    t.date "death_date"
    t.uuid "el_recodo_person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["el_recodo_person_id"], name: "index_people_on_el_recodo_person_id"
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
    t.string "playlistable_type", null: false
    t.uuid "playlistable_id", null: false
    t.string "item_type", null: false
    t.uuid "item_id", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_type", "item_id"], name: "index_playlist_items_on_item"
    t.index ["playlistable_type", "playlistable_id"], name: "index_playlist_items_on_playlistable"
    t.index ["position"], name: "index_playlist_items_on_position"
  end

  create_table "playlists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle"
    t.text "description"
    t.string "slug"
    t.boolean "public", default: true, null: false
    t.boolean "system", default: false, null: false
    t.uuid "user_id"
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

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
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

  create_table "tandas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle"
    t.text "description"
    t.string "slug"
    t.boolean "public", default: true, null: false
    t.boolean "system", default: false, null: false
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_tandas_on_slug", unique: true
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

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "email", null: false
    t.citext "username"
    t.string "password_digest", null: false
    t.string "provider"
    t.string "uid"
    t.boolean "admin", default: false, null: false
    t.datetime "approved_at"
    t.datetime "confirmed_at"
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "waveform_data", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.float "data", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "waveforms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "version", null: false
    t.integer "channels", null: false
    t.integer "sample_rate", null: false
    t.integer "samples_per_pixel", null: false
    t.integer "bits", null: false
    t.integer "length", null: false
    t.uuid "digital_remaster_id", null: false
    t.uuid "waveform_datum_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["digital_remaster_id"], name: "index_waveforms_on_digital_remaster_id"
    t.index ["waveform_datum_id"], name: "index_waveforms_on_waveform_datum_id"
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
  add_foreign_key "events", "users"
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
  add_foreign_key "recording_singers", "people"
  add_foreign_key "recording_singers", "recordings"
  add_foreign_key "recordings", "compositions"
  add_foreign_key "recordings", "external_catalog_el_recodo_songs", column: "el_recodo_song_id"
  add_foreign_key "recordings", "genres"
  add_foreign_key "recordings", "orchestras"
  add_foreign_key "recordings", "record_labels"
  add_foreign_key "recordings", "time_periods"
  add_foreign_key "sessions", "users"
  add_foreign_key "shares", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "users"
  add_foreign_key "waveforms", "digital_remasters"
  add_foreign_key "waveforms", "waveform_data"
end
