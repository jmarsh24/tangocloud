FactoryBot.define do
  factory :playlist_item do
    association :playlist
    association :item, factory: :recording
    position { playlist.playlist_items.size + 1 }
  end
end

# == Schema Information
#
# Table name: playlist_items
#
#  id          :uuid             not null, primary key
#  playlist_id :uuid             not null
#  item_type   :string           not null
#  item_id     :uuid             not null
#  position    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
