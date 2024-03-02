module Mutations::UserActivity
  class CreateListen < Mutations::BaseMutation
    argument :recording_id, ID, required: true

    field :listen, Types::ListenType, null: false

    def resolve(recording_id:)
      RecordingListen.create!(
        recording_id:
      )
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(", ")}")
    end
  end
end
