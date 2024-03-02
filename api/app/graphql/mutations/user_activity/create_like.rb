module Mutations::UserActivity
  class CreateLike < Mutations::BaseMutation
    field :like, Types::LikeType, null: true
    field :errors, Types::ValidationErrorsType, null: true

    argument :likeable_type, String, required: true
    argument :likeable_id, ID, required: true

    def resolve(likeable_type:, likeable_id:)
      like = Like.create!(
        likeable_type:,
        likeable_id:,
        user: context[:current_user]
      )

    if like.save
      {like:, success: true}
    else
      {errors: like.errors, success: false}
    end
  end
end
