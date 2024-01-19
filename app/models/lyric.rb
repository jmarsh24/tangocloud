# frozen_string_literal: true

# == Schema Information
#
# Table name: lyrics
#
#  id             :integer          not null, primary key
#  locale         :string           not null
#  content        :text             not null
#  composition_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Lyric < ApplicationRecord
  belongs_to :composition

  validates :locale, presence: true
  validates :content, presence: true
end
