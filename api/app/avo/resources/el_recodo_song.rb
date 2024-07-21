class Avo::Resources::ElRecodoSong < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, hide_on: [:index]
    field :date, as: :date
    field :ert_number, as: :number do
      link_to record.ert_number, "https://www.el-recodo.com/music?id=#{record.ert_number}&lang=en", target: "_blank"
    end
    field :title, as: :text
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
    field :orchestra, as: :text

    field :el_recodo_person_roles, as: :has_many
    field :el_recodo_people, as: :has_many, through: :el_recodo_person_roles
    field :lyricist_roles, as: :has_many
    field :lyricists, as: :has_many, through: :lyricist_roles
    field :pianist_roles, as: :has_many
    field :pianists, as: :has_many, through: :pianist_roles
    field :arranger_roles, as: :has_many
    field :arrangers, as: :has_many, through: :arranger_roles
    field :doublebassist_roles, as: :has_many
    field :doublebassists, as: :has_many, through: :doublebassist_roles
    field :bandoneonist_roles, as: :has_many
    field :bandoneonists, as: :has_many, through: :bandoneonist_roles
    field :violinist_roles, as: :has_many
    field :violinists, as: :has_many, through: :violinist_roles
    field :singer_roles, as: :has_many
    field :singers, as: :has_many, through: :singer_roles
    field :composer_roles, as: :has_many
    field :composers, as: :has_many, through: :composer_roles
    field :celloist_roles, as: :has_many
    field :celloists, as: :has_many, through: :celloist_roles
    field :director_roles, as: :has_many, through: :director
    field :director, as: :has_one
    field :soloist_roles, as: :has_many, through: :soloist
    field :soloist, as: :has_one
    field :recording, as: :has_one
  end
end
