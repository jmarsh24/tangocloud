class Playlist < ApplicationRecord
  include Playlistable

  has_many :tandas, through: :playlist_items, source: :item, source_type: "Tanda"
end

# == Schema Information
#
# Table name: playlists
#
#  id          :uuid             not null, primary key
#  title       :string           not null
#  subtitle    :string
#  description :text
#  slug        :string
#  public      :boolean          default(TRUE), not null
#  system      :boolean          default(FALSE), not null
#  user_id     :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
