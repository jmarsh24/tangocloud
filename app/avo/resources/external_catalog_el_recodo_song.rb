class Avo::Resources::ExternalCatalogElRecodoSong < Avo::BaseResource
  self.includes = [:person_roles, :people, orchestra: [image_attachment: :blob], people: [image_attachment: :blob], recording: [:composition]]
  # self.attachments = []
  self.model_class = ::ExternalCatalog::ElRecodo::Song
  self.search = {
    query: -> {
      query.search(
        params[:q],
        fields: [:title, :style, :label, :orchestra, :singer],
        match: :word_start, misspellings: {below: 5}
      )
    }
  }

  self.title = :formatted_title

  def fields
    field :id, as: :id, hide_on: [:index]
    field :image, as: :file, is_image: true do
      record&.orchestra&.image || record.people.find { _1.image.attached? }&.image
    end
    field :date, as: :date
    field :ert_number, as: :number
    field :el_recodo do
      link_to "Link", "https://www.el-recodo.com/music?id=#{record.ert_number}&lang=en", target: "_blank"
    end
    field :title, as: :text
    field :style, as: :text
    field :label, as: :text
    field :instrumental, as: :boolean
    field :lyrics, as: :textarea, hide_on: [:index]
    field :lyrics_year, as: :number, hide_on: [:index]
    field :search_data, as: :text, hide_on: [:index]
    field :matrix, as: :text, hide_on: [:index]
    field :disk, as: :text, hide_on: [:index]
    field :speed, as: :number, hide_on: [:index]
    field :duration, as: :number, hide_on: [:index]
    field :synced_at, as: :date_time, hide_on: [:index]
    field :page_updated_at, as: :date_time, hide_on: [:index]
    field :orchestra, as: :belongs_to
    field :person_roles, as: :has_many
    field :people, as: :has_many, through: :person_roles
    field :recording, as: :has_one
  end
end
