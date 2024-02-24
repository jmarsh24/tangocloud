class CompositionLyric < ApplicationRecord
  belongs_to :composition
  belongs_to :lyric
end

# == Schema Information
#
# Table name: composition_lyrics
#
#  id             :bigint           not null, primary key
#  composition_id :uuid             not null
#  lyric_id       :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
