module Mutations::UserActivity
  class CreateLike < Mutations::BaseMutation
    field :like, Types::LikeType, null: true
    field :success, Boolean, null: false
    field :errors, Types::ValidationErrorsType, null: true

    argument :likeable_type, String, required: true
    argument :likeable_id, ID, required: true

    def resolve(likeable_type:, likeable_id:)
      like = Like.new(
        likeable_type:,
        likeable_id:,
        user: context[:current_user]
      )

      if like.save
        {like:, success: true, errors: nil}
      else
        {like: nil, success: false, errors: like.errors}
      end
    rescue NameError
      raise GraphQL::ExecutionError, "Likeable type is not a valid type"
    end
  end
end
