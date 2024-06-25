class Avo::Resources::MoodTag < Avo::BaseResource
  self.title = :id
  self.includes = [:mood, :taggable, :user]
  # self.search_query = ->(params:) do
  #   scope.ransack(id_eq: params[:q], mood_id_eq: params[:q], user_id_eq: params[:q]).result(distinct: false)
  # end
  def fields
    field :id, as: :id
    field :mood, as: :belongs_to
    field :taggable, as: :polymorphic_belongs_to
    field :user, as: :belongs_to

    field :created_at, as: :date_time
    field :updated_at, as: :date_time
  end
end
