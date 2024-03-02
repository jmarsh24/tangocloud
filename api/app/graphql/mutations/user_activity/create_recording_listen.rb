module Mutations::UserActivity
  class CreateRecordingListen < Mutations::BaseMutation
    argument :recording_id, ID, required: true

    field :recording_listen, Types::RecordingListenType, null: false

    def resolve(recording_id:)
      recording_listen = Current.user.user_history.listens.new(
        recording_id:
      )

      if recording_listen.save
        {recording_listen:}
      else
        {errors: recording_listen.errors}
      end

    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(", ")}")
    end
  end
end
