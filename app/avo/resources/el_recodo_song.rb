class Avo::Resources::ElRecodoSong < Avo::BaseResource
  self.includes = [
    :recording,
    :el_recodo_person_roles,
    el_recodo_people: [image_attachment: :blob],
    el_recodo_orchestra: [image_attachment: :blob]
  ]
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
    field :title, as: :text
    field :image, as: :file, is_image: true do
      record&.el_recodo_orchestra&.image || record.el_recodo_people.find { |person| person.image.attached? }&.image
    end
    field :ert_number
    field :external_link, as: :text do
      link_to "Link", "https://www.el-recodo.com/music?id=#{record.ert_number}&lang=en", target: "_blank"
    end
    field :date, as: :date
    field :el_recodo_orchestra, as: :belongs_to
    field :style, as: :text
    field :label, as: :text
    field :instrumental, as: :boolean
    field :lyrics, as: :textarea, hide_on: [:index]
    field :lyrics_year, as: :number, hide_on: [:index]
    field :matrix, as: :text, hide_on: [:index]
    field :disk, as: :text, hide_on: [:index]
    field :speed, as: :number, hide_on: [:index]
    field :duration, as: :number, hide_on: [:index]
    field :synced_at, as: :date_time, hide_on: [:index]
    field :page_updated_at, as: :date_time, hide_on: [:index]

    field :el_recodo_person_roles, as: :has_many
    field :el_recodo_people, as: :has_many, through: :el_recodo_person_roles, hide_on: [:show]

    field :recording, as: :has_one
  end
end
