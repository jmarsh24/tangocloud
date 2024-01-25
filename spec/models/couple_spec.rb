# frozen_string_literal: true

# == Schema Information
#
# Table name: couples
#
#  id         :uuid             not null, primary key
#  dancer_id  :uuid             not null
#  partner_id :uuid             not null
#
require "rails_helper"

RSpec.describe Couple, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
