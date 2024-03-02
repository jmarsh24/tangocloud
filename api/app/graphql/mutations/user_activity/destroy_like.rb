module Mutations::UserActivity
  class DestroyLike < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false

    def resolve(id:)
      like = Like.find(id)
      like.destroy
      { message: "Like successfully deleted" }
    rescue ActiveRecord::RecordNotFound => e
      GraphQL::ExecutionError.new("Error: #{e.message}")
    end
  end
end
