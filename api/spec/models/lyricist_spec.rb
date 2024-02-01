# == Schema Information
#
# Table name: lyricists
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  sort_name  :string
#  birth_date :date
#  death_date :date
#  bio        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Lyricist, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
