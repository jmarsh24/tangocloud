FactoryBot.define do
  factory :recording do
    recorded_date { Faker::Date.between(from: "1900-01-01", to: "2020-12-31") }
    recording_type { ["studio", "live"].sample }
    playbacks_count { Faker::Number.between(from: 0, to: 10000) }
    association :orchestra
    association :genre
    association :composition
    # association :time_period
    association :record_label
    association :el_recodo_song

    transient do
      composition_title { nil }
    end

    after(:create) do |recording, evaluator|
      if evaluator.composition_title
        recording.composition = build(:composition, title: evaluator.composition_title)
      end
    end
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
#  playbacks_count   :integer          default(0), not null
#  el_recodo_song_id :uuid
#  orchestra_id      :uuid             not null
#  composition_id    :uuid             not null
#  genre_id          :uuid             not null
#  record_label_id   :uuid
#  time_period_id    :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
