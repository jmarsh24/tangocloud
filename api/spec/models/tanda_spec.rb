require "rails_helper"

RSpec.describe Tanda, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: tandas
#
#  id                :uuid             not null, primary key
#  name              :string           not null
#  description       :string
#  public            :boolean          default(TRUE), not null
#  audio_transfer_id :uuid             not null
#  user_id           :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
