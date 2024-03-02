module Mutations::UserActivity
  class DestroyLike < Mutations::BaseMutation
    field :success, Boolean, null: false
    field :errors, Types::ValidationErrorsType, null: true

    argument :like_id, ID, required: false
    argument :likeable_type, String, required: false
    argument :likeable_id, ID, required: false

    def resolve(id: nil, likeable_type: nil, likeable_id: nil)
      user = context[:current_user]
      like = if id
        Like.find_by(id:, user:)
      else
        Like.find_by(likeable_type:, likeable_id:, user:)
      end

      return {success: false, errors: {fullMessages: ["Like not found"]}} unless like

      if like.destroy
        {success: true, errors: nil}
      else
        {success: false, errors: like.errors}
      end
    end
  end
end
