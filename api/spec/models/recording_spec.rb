# == Schema Information
#
# Table name: recordings
#
#  id                :uuid             not null, primary key
#  title             :string           not null
#  bpm               :integer
#  release_date      :date
#  recorded_date     :date
#  el_recodo_song_id :uuid
#  orchestra_id      :uuid
#  singer_id         :uuid
#  composition_id    :uuid
#  record_label_id   :uuid
#  genre_id          :uuid
#  period_id         :uuid
#  recording_type    :enum             default("studio"), not null
#  slug              :string
#
require "rails_helper"

RSpec.describe Recording, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
