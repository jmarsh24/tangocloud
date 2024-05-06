class Avo::Resources::UserPreference < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :avatar, as: :file, is_image: true, display_filename: false
    field :first_name, as: :text
    field :last_name, as: :text
  end
end
