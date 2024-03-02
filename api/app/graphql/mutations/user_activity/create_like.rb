module Mutations::UserActivity
  class CreateLike < Mutations::BaseMutation
    field :like, Types::LikeType, null: true
    field :errors, Types::ValidationErrorsType, null: true

    argument :likeable_type, String, required: true
    argument :likeable_id, ID, required: true

    def resolve(likeable_type:, likeable_id:)
      Like.create!(
        likeable_type:,
        likeable_id:,
        user: context[:current_user]
      )
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(", ")}")
    end
  end
end
