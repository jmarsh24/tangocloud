class ExternalCatalog::ElRecodo::Song < ApplicationRecord
  searchkick word_start: [:title, :composer, :author, :lyrics, :orchestra, :singer], callbacks: :async

  belongs_to :el_recodo_orchestra, class_name: "ExternalCatalog::ElRecodo::Orchestra", optional: true
  belongs_to :orchestra, optional: true

  has_many :person_roles, class_name: "ExternalCatalog::ElRecodo::PersonRole", dependent: :destroy
  has_many :people, through: :person_roles, source: :person, class_name: "ExternalCatalog::ElRecodo::Person"

  has_one :recording, class_name: "Recording", foreign_key: "el_recodo_song_id", inverse_of: :el_recodo_song, dependent: :nullify

  validates :date, presence: true
  validates :ert_number, presence: true, uniqueness: true
  validates :title, presence: true

  before_save :set_formatted_title

  scope :search_import, -> { includes(:orchestra, :people) }

  def singers
    people.joins(:person_roles).merge(ExternalCatalog::ElRecodo::PersonRole.singers)
  end

  private

  def search_data
    {
      date:,
      ert_number:,
      title:,
      style:,
      label:,
      lyrics:,
      orchestra: orchestra&.name,
      people: people&.map(&:name)
    }
  end

  def set_formatted_title
    singer_names = singers.map(&:name)
    singers_text = singer_names.presence&.join(", ") || "Instrumental"

    elements = [
      title,
      orchestra&.name,
      singers_text,
      date&.year,
      style
    ].reject(&:blank?)

    self.formatted_title = elements.join(" • ")
  end
end

# == Schema Information
#
# Table name: external_catalog_el_recodo_songs
#
#  id                     :uuid             not null, primary key
#  date                   :date             not null
#  ert_number             :integer          default(0), not null
#  title                  :string           not null
#  formatted_title        :string
#  style                  :string
#  label                  :string
#  instrumental           :boolean          default(TRUE), not null
#  lyrics                 :text
#  lyrics_year            :integer
#  search_data            :string
#  matrix                 :string
#  disk                   :string
#  speed                  :integer
#  duration               :integer
#  synced_at              :datetime         not null
#  page_updated_at        :datetime
#  orchestra_id           :uuid
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  el_recodo_orchestra_id :uuid
#
