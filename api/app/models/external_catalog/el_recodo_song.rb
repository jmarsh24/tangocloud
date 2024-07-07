# == Schema Information
#
# Table name: el_recodo_songs
#
#  id              :uuid             not null, primary key
#  date            :date             not null
#  ert_number      :integer          default(0), not null
#  music_id        :integer          default(0), not null
#  title           :string           not null
#  style           :string
#  orchestra       :string
#  singer          :string
#  soloist         :string
#  director        :string
#  composer        :string
#  author          :string
#  label           :string
#  members         :jsonb            not null
#  lyrics          :text
#  search_data     :string
#  synced_at       :datetime         not null
#  page_updated_at :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
module ExternalCatalog
  class ElRecodoSong < ApplicationRecord
    searchkick word_start: [:title, :composer, :author, :lyrics, :orchestra, :singer], callbacks: :async

    has_one :recording, dependent: :nullify

    validates :date, presence: true
    validates :ert_number, presence: true
    validates :music_id, presence: true, uniqueness: true
    validates :title, presence: true
    validates :page_updated_at, presence: true

    def search_data
      {
        date:,
        ert_number:,
        music_id:,
        title:,
        style:,
        orchestra:,
        singer:,
        composer:,
        author:,
        label:,
        lyrics:,
        soloist:,
        director:
      }
    end
  end

  # == Schema Information
  #
  # Table name: el_recodo_songs
  #
  #  id                   :uuid             not null, primary key
  #  date                 :date             not null
  #  ert_number           :integer          default(0), not null
  #  music_id             :integer          default(0), not null
  #  title                :string           not null
  #  style                :string
  #  orchestra            :string
  #  singer               :string
  #  soloist              :string
  #  director             :string
  #  composer             :string
  #  author               :string
  #  label                :string
  #  lyrics               :text
  #  normalized_title     :string
  #  normalized_orchestra :string
  #  normalized_singer    :string
  #  normalized_composer  :string
  #  normalized_author    :string
  #  search_data          :string
  #  synced_at            :datetime         not null
  #  page_updated_at      :datetime         not null
  #  created_at           :datetime         not null
  #  updated_at           :datetime         not null
  #
end
