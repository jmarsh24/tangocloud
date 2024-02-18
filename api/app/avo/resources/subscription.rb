class Avo::Resources::Subscription < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :start_date, as: :date_time
    field :end_date, as: :date_time
    field :subscription_type, as: :select, enum: ::Subscription.subscription_types
    field :user_id, as: :text
    field :user, as: :belongs_to
  end
end
