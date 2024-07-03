FactoryBot.define do
  factory :playlist_item do
    association :playlist
    association :item, factory: :recording
    position { playlist.playlist_items.size + 1 }
  end
end
