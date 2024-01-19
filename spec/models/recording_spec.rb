# frozen_string_literal: true

# == Schema Information
#
# Table name: recordings
#
#  id             :integer          not null, primary key
#  title          :string           not null
#  bpm            :integer
#  type           :integer          default("studio"), not null
#  release_date   :date
#  recorded_date  :date
#  tangotube_slug :string
#  orchestra_id   :integer
#  singer_id      :integer
#  composition_id :integer
#  label_id       :integer
#  genre_id       :integer
#  period_id      :integer
#
require "rails_helper"

RSpec.describe Recording, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
