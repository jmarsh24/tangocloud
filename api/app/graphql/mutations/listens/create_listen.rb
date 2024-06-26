module Mutations::Listens
  class CreateListen < Mutations::BaseMutation
    argument :recording_id, ID, required: true

    field :listen, Types::ListenType, null: true
    field :errors, [String], null: false

    def resolve(recording_id:)
      listen = current_user.listens.new(
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
