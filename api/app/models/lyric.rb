class Lyric < ApplicationRecord
  belongs_to :composition

  validates :locale, presence: true
  validates :content, presence: true
  validates :locale, uniqueness: {scope: :composition_id}
end

# == Schema Information
#
# Table name: lyrics
#
#  id             :uuid             not null, primary key
#  locale         :string           not null
#  content        :text             not null
#  composition_id :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
