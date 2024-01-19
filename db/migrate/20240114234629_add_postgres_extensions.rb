# frozen_string_literal: true

class AddPostgresExtensions < ActiveRecord::Migration[7.1]
  def change
    enable_extension "btree_gin"
    enable_extension "btree_gist"
    enable_extension "citext"
    enable_extension "fuzzystrmatch"
    enable_extension "pg_stat_statements"
    enable_extension "pgcrypto"
    enable_extension "pg_trgm"
    enable_extension "unaccent"
  end
end
