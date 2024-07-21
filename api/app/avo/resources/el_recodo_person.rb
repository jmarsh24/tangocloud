class Avo::Resources::ElRecodoPerson < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, hide_on: [:index]
    field :name, as: :text
    field :image, as: :file, is_image: true
    field :birth_date, as: :date
    field :death_date, as: :date
    field :real_name, as: :text
    field :nicknames, as: :text
    field :place_of_birth, as: :text
    field :path, as: :text do
      link_to record.name, "https://el-recodo.com/#{record.path}", target: "_blank"
    end
    field :synced_at, as: :date_time, hide_on: [:index]
    field :el_recodo_person_roles, as: :has_many
    field :el_recodo_songs, as: :has_many, through: :el_recodo_person_roles
  end
end
