module Mutations::ListenHistories
  class RemoveListen < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false

    def resolve(id:)
      listen = Listen.find(id)

      if listen.destroy
        {message: "Listen successfully deleted", success: true}
      else
        {errors: listen.errors, success: false}
      end
    rescue ActiveRecord::RecordNotFound => e
      GraphQL::ExecutionError.new("Error: #{e.message}")
    end
  end
end
