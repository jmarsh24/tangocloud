# == Schema Information
#
# Table name: labels
#
#  id           :uuid             not null, primary key
#  name         :string           not null
#  description  :text
#  founded_date :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "rails_helper"

RSpec.describe Label, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
