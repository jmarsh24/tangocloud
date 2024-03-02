module Mutations::UserActivity
  class CreateListen < Mutations::BaseMutation
    argument :recording_id, ID, required: true

    type Types::ListenType

    def resolve(recording_id:)
      Listen.create!(
        recording_id:
      )
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(", ")}")
    end
  end
end
