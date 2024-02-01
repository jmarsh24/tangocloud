require "rails_helper"

RSpec.describe Video, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: videos
#
#  id           :uuid             not null, primary key
#  youtube_slug :string           not null
#  title        :string           not null
#  description  :string           not null
#  recording_id :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
