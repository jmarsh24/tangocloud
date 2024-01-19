# frozen_string_literal: true

# == Schema Information
#
# Table name: albums
#
#  id                :integer          not null, primary key
#  title             :string           not null
#  description       :text
#  release_date      :date
#  type              :integer          default("compilation"), not null
#  recordings_count  :integer          default(0), not null
#  slug              :string           not null
#  external_id       :string
#  transfer_agent_id :integer
#
require "rails_helper"

RSpec.describe Album, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
