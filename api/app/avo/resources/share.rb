class Avo::Resources::Share < Avo::BaseResource
  self.title = :id
  self.includes = [:user, :shareable]
  # self.search_query = ->(params:) do
  #   scope.ransack(id_eq: params[:q], user_id_eq: params[:q]).result(distinct: false)
  # end

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :shareable, as: :polymorphic_belongs_to

    field :created_at, as: :date_time
    field :updated_at, as: :date_time
  end
end
