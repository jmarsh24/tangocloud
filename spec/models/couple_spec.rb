# frozen_string_literal: true

# == Schema Information
#
# Table name: couples
#
#  id         :integer          not null, primary key
#  dancer_id  :integer          not null
#  partner_id :integer          not null
#
require "rails_helper"

RSpec.describe Couple, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
