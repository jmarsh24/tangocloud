# == Schema Information
#
# Table name: couple_videos
#
#  id        :uuid             not null, primary key
#  couple_id :uuid             not null
#  video_id  :uuid             not null
#
require "rails_helper"

RSpec.describe CoupleVideo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
