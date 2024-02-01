require "rails_helper"

RSpec.describe Lyric, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: lyrics
#
#  id             :uuid             not null, primary key
#  locale         :string           not null
#  content        :text             not null
#  composition_id :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
