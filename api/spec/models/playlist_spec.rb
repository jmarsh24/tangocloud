require "rails_helper"

RSpec.describe Playlist, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: playlists
#
#  id              :uuid             not null, primary key
#  title           :string           not null
#  description     :string
#  public          :boolean          default(TRUE), not null
#  songs_count     :integer          default(0), not null
#  likes_count     :integer          default(0), not null
#  listens_count   :integer          default(0), not null
#  shares_count    :integer          default(0), not null
#  followers_count :integer          default(0), not null
#  user_id         :uuid             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
