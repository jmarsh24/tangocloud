module Mutations
  module Recordings
    class RemoveLikeFromRecording < Mutations::BaseMutation
      field :errors, [String], null: false
      field :success, Boolean, null: false

      argument :recording_id, ID, required: true

      def resolve(recording_id:)
        recording = Recording.find(recording_id)

        if recording.nil?
          return {success: false, errors: ["Recording not found"]}
        end

        like = current_user.likes.find_by(likeable: recording)

        if like.nil?
          return {success: false, errors: ["Like not found"]}
        end

        if like.destroy
          {success: true, errors: []}
        else
          {success: false, errors: like.errors.full_messages}
        end
      end
    end
  end
end
