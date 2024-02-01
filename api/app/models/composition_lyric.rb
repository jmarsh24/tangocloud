# == Schema Information
#
# Table name: composition_lyrics
#
#  id             :bigint           not null, primary key
#  locale         :string           not null
#  composition_id :uuid             not null
#  lyricist_id    :uuid             not null
#  lyrics_id      :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class CompositionLyric < ApplicationRecord
  belongs_to :composition
  belongs_to :composer
  belongs_to :lyricist
end
