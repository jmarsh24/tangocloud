FactoryBot.define do
  factory :recording do
    recorded_date { Faker::Date.between(from: "1900-01-01", to: "2020-12-31") }
    recording_type { ["studio", "live"].sample }
    listens_count { Faker::Number.between(from: 0, to: 10000) }
    association :orchestra
    association :genre
    association :composition, factory: :composition
  end
end

# == Schema Information
#
# Table name: recordings
#
#  id                :uuid             not null, primary key
#  recorded_date     :date
#  slug              :string           not null
#  recording_type    :enum             default("studio"), not null
#  listens_count     :integer          default(0), not null
#  el_recodo_song_id :uuid
#  orchestra_id      :uuid
#  composition_id    :uuid
#  record_label_id   :uuid
#  genre_id          :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
