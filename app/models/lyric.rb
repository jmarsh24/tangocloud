class Lyric < ApplicationRecord
  belongs_to :composition
  belongs_to :language

  validates :text, presence: true
end

# == Schema Information
#
# Table name: lyrics
#
#  id             :uuid             not null, primary key
#  text           :text             not null
#  composition_id :uuid             not null
#  language_id    :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
