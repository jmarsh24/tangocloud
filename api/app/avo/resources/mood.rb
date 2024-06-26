class Avo::Resources::Mood < Avo::BaseResource
  self.title = :name
  self.includes = [:mood_tags, :taggable_recordings, :taggable_tandas, :users]
  # self.search_query = ->(params:) do
  #   scope.ransack(name_cont: params[:q], id_eq: params[:q]).result(distinct: false)
  # end
  def fields
    field :id, as: :id
    field :name, as: :text

    field :mood_tags, as: :has_many
    field :taggable_recordings, as: :has_many, through: :mood_tags, source: :taggable, source_type: "Recording"
    field :taggable_tandas, as: :has_many, through: :mood_tags, source: :taggable, source_type: "Tanda"
    field :users, as: :has_many, through: :mood_tags

    field :created_at, as: :date_time
    field :updated_at, as: :date_time
  end
end
