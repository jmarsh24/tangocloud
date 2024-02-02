require "rails_helper"

RSpec.describe Album, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: albums
#
#  id               :uuid             not null, primary key
#  title            :string           not null
#  description      :text
#  release_date     :date
#  recordings_count :integer          default(0), not null
#  slug             :string           not null
#  external_id      :string
#  album_type       :enum             default("compilation"), not null
#
