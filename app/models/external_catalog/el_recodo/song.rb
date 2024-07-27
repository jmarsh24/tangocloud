class ExternalCatalog::ElRecodo::Song < ApplicationRecord
  searchkick word_start: [:title, :composer, :author, :lyrics, :orchestra, :singer], callbacks: :async

  belongs_to :orchestra, class_name: "ExternalCatalog::ElRecodo::Orchestra", optional: true

  has_many :person_roles, class_name: "ExternalCatalog::ElRecodo::PersonRole", inverse_of: :song, dependent: :destroy
  has_many :people, through: :person_roles, source: :person, class_name: "ExternalCatalog::ElRecodo::Person"

  has_one :recording, dependent: :nullify

  has_many :singers, -> { where(person_roles: {role: "singer"}) }, through: :person_roles, source: :person, class_name: "ExternalCatalog::ElRecodo::Person"

  validates :date, presence: true
  validates :ert_number, presence: true, uniqueness: true
  validates :title, presence: true
  validates :page_updated_at, presence: true

  def search_data
    {
      date:,
      ert_number:,
      title:,
      style:,
      label:,
      lyrics:,
      orchestra: orchestra&.name,
      people: people.map(&:name)
    }
  end

  def formatted_title
    elements = [
      title,
      orchestra&.name,
      singers.map(&:name).join(", "),
      date&.year,
      style
    ].reject(&:blank?)
    elements.join(" • ")
  end
end

# == Schema Information
#
# Table name: external_catalog_el_recodo_songs
#
#  id              :uuid             not null, primary key
#  date            :date             not null
#  ert_number      :integer          default(0), not null
#  title           :string           not null
#  style           :string
#  label           :string
#  instrumental    :boolean          default(TRUE), not null
#  lyrics          :text
#  lyrics_year     :integer
#  search_data     :string
#  matrix          :string
#  disk            :string
#  speed           :integer
#  duration        :integer
#  synced_at       :datetime         not null
#  page_updated_at :datetime
#  orchestra_id    :uuid
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
