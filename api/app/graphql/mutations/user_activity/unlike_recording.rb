module Mutations::UserActivity
  class UnlikeRecording < Mutations::BaseMutation
    field :success, Boolean, null: false
    field :errors, Types::ValidationErrorsType, null: true

    argument :id, ID, required: false

    def resolve(id: nil)
      like = Like.find_by(id:, user: context[:current_user])

      unless like
        raise GraphQL::ExecutionError, "Like not found"
      end

      if like.destroy
        {success: true, errors: nil}
      else
        {success: false, errors: like.errors}
      end
    end
  end
end
