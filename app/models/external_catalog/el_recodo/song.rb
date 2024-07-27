class ExternalCatalog::ElRecodo::Song < ApplicationRecord
  searchkick word_start: [:title, :composer, :author, :lyrics, :orchestra, :singer], callbacks: :async

  belongs_to :orchestra, optional: true, class_name: "ExternalCatalog::ElRecodo::Orchestra"

  has_many :person_roles, dependent: :destroy, class_name: "ExternalCatalog::ElRecodo::PersonRole"
  has_many :people, through: :el_recodo_person_roles, class_name: "ExternalCatalog::ElRecodo::Person"

  has_one :recording, dependent: :nullify

  has_many :singers, -> { where(el_recodo_person_roles: {role: "singer"}) }, through: :el_recodo_person_roles, source: :el_recodo_person, class_name: "ExternalCatalog::ElRecodo::Person"

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
      orchestra: el_recodo_orchestra&.name,
      people: people.map(&:name)
    }
  end

  def formatted_title
    elements = [
      title,
      el_recodo_orchestra&.name,
      singers.map(&:name).join(", "),
      date&.year,
      style
    ].reject(&:blank?)
    elements.join(" • ")
  end
end
