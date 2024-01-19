# frozen_string_literal: true

# == Schema Information
#
# Table name: singers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  rank       :integer          default(0), not null
#  sort_name  :string
#  bio        :text
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Singer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
