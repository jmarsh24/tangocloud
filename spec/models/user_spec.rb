# frozen_string_literal: true

# == Schema Information
#
# Table name: action_auth_users
#
#  id              :uuid             not null, primary key
#  email           :string
#  password_digest :string
#  verified        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  webauthn_id     :string
#
require "rails_helper"

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
