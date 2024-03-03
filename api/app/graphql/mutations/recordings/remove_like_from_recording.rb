module Mutations::Recordings
  class RemoveLikeFromRecording < Mutations::BaseMutation
    field :success, Boolean, null: false
    field :errors, [String], null: false

    argument :id, ID, required: true

    def resolve(id:)
      like = Like.find_by(id:)

      return {success: false, errors: ["Like not found"]} if like.nil?

      if like.destroy
        {success: true, errors: []}
      else
        {success: false, errors: like.errors}
      end
    end
  end
end
