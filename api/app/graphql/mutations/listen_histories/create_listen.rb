module Mutations::ListenHistories
  class CreateListen < Mutations::BaseMutation
    argument :recording_id, ID, required: true

    field :listen, Types::ListenType, null: false

    def resolve(recording_id:)
      listen = current_user.listen_history.listens.new(
        recording_id:
      )

      if listen.save
        {listen:}
      else
        {errors: listen.errors}
      end
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(", ")}")
    end
  end
end
