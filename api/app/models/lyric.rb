class Lyric < ApplicationRecord
  belongs_to :composition

  validates :locale, presence: true
  validates :content, presence: true
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
