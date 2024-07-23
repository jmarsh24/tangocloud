class Avo::Resources::ElRecodoPersonRole < Avo::BaseResource
  self.includes = [:el_recodo_person, :el_recodo_song, el_recodo_person: [image_attachment: :blob]]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, hide_on: [:index]
    field :role, as: :text do
      record.role.capitalize
    end
    field :image, as: :file, is_image: true do
      record.el_recodo_person.image
    end
    field :el_recodo_person, as: :belongs_to
    field :el_recodo_song, as: :belongs_to
    field :external_link, as: :text do
      link_to "Link", "https://el-recodo.com/#{record.el_recodo_person.path}", target: "_blank"
    end
  end
end
