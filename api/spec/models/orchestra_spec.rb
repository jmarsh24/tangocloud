require "rails_helper"

RSpec.describe Orchestra, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: orchestras
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  rank       :integer          default(0), not null
#  sort_name  :string
#  birth_date :date
#  death_date :date
#  slug       :string           not null
#
