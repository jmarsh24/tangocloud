# == Schema Information
#
# Table name: dancer_videos
#
#  id        :uuid             not null, primary key
#  dancer_id :uuid             not null
#  video_id  :uuid             not null
#
require "rails_helper"

RSpec.describe DancerVideo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
