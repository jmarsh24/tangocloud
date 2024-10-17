FactoryBot.define do
  factory :playlist_item do
    association :playlistable, factory: :playlist
    association :item, factory: :recording
    position { playlistable.playlist_items.size + 1 }

    trait :with_tanda do
      association :item, factory: :tanda
    end
  end
end

# == Schema Information
#
# Table name: playlist_items
#
#  id                :integer          not null, primary key
#  playlistable_type :string           not null
#  playlistable_id   :integer          not null
#  item_type         :string           not null
#  item_id           :integer          not null
#  position          :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
