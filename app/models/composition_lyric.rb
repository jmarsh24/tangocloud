class CompositionLyric < ApplicationRecord
  belongs_to :composition
  belongs_to :lyric
end

# == Schema Information
#
# Table name: composition_lyrics
#
#  id             :integer          not null, primary key
#  composition_id :integer          not null
#  lyric_id       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
