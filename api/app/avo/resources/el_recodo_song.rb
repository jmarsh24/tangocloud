class Avo::Resources::ElRecodoSong < Avo::BaseResource
  self.includes = [
    :el_recodo_orchestra,
    :recording,
    :el_recodo_person_roles,
    :el_recodo_people
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
    field :date, as: :date
    field :ert_number, as: :number do
      link_to record.ert_number, "https://www.el-recodo.com/music?id=#{record.ert_number}&lang=en", target: "_blank"
    end
    field :title, as: :text
    field :el_recodo_orchestra, as: :belongs_to
    field :style, as: :text
    field :label, as: :text
    field :instrumental, as: :boolean
    field :lyrics, as: :textarea
    field :lyrics_year, as: :number
    field :matrix, as: :text
    field :disk, as: :text
    field :speed, as: :number
    field :duration, as: :number
    field :synced_at, as: :date_time, hide_on: [:index]
    field :page_updated_at, as: :date_time, hide_on: [:index]

    field :el_recodo_person_roles, as: :has_many
    field :el_recodo_people, as: :has_many, through: :el_recodo_person_roles

    ElRecodoPersonRole::ROLES.each do |role|
      role_plural = role.pluralize.to_sym
      field :"#{role}_roles", as: :has_many
      field role_plural, as: :has_many, through: :"#{role}_roles"
    end

    field :recording, as: :has_one
  end
end
