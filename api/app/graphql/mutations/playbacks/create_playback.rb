module Mutations::Playbacks
  class CreatePlayback < Mutations::BaseMutation
    argument :recording_id, ID, required: true

    field :playback, Types::PlaybackType, null: true
    field :errors, [String], null: false

    def resolve(recording_id:)
      playback = current_user.playbacks.new(
        recording_id:
      )

      if playback.save
        {playback:}
      else
        {errors: playback.errors}
      end
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(", ")}")
    end
  end
end
