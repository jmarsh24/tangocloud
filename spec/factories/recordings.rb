FactoryBot.define do
  factory :recording do
    recorded_date { Faker::Date.between(from: "1900-01-01", to: "2020-12-31") }
    recording_type { ["studio", "live"].sample }
    playbacks_count { Faker::Number.between(from: 0, to: 10000) }
    association :orchestra
    association :genre
    association :composition
    association :time_period
    association :record_label
    association :el_recodo_song, factory: :external_catalog_el_recodo_song
  end
end

# == Schema Information
#
# Table name: recordings
#
#  id                :integer          not null, primary key
#  recorded_date     :date
#  slug              :string           not null
#  recording_type    :integer          default("studio"), not null
#  playbacks_count   :integer          default(0), not null
#  el_recodo_song_id :integer
#  orchestra_id      :integer
#  composition_id    :integer          not null
#  genre_id          :integer          not null
#  record_label_id   :integer
#  time_period_id    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
