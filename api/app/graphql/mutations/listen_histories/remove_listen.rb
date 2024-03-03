module Mutations::ListenHistories
  class RemoveListen < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false
    field :success, Boolean, null: false
    field :errors, [String], null: true

    def resolve(id:)
      listen = Listen.find(id)

      if listen.destroy
        {message: "Listen successfully deleted", success: true}
      else
        {errors: listen.errors, success: false}
      end
    rescue ActiveRecord::RecordNotFound => e
      {errors: [e.message], success: false}
    end
  end
end
