class NowPlaying < ApplicationRecord
  belongs_to :user
  belongs_to :item, polymorphic: true
end
# == Schema Information
#
# Table name: now_playings
#
#  id        :uuid             not null, primary key
#  user_id   :uuid             not null
#  item_type :string           not null
#  item_id   :uuid             not null
#  position  :integer          default(0), not null
#
