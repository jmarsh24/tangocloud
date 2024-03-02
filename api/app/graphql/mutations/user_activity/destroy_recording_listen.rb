module Mutations::UserActivity
  class DestroyRecordingListen < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false

    def resolve(id:)
      listen = Listen.find(id)
      listen.destroy
      {message: "Listen successfully deleted"}
    rescue ActiveRecord::RecordNotFound => e
      GraphQL::ExecutionError.new("Error: #{e.message}")
    end
  end
end
