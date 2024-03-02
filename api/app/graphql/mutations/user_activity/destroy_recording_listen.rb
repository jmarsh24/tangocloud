module Mutations::UserActivity
  class DestroyRecordingListen < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false

    def resolve(id:)
      recording_listen = RecordingListen.find(id)

      if recording_listen.destroy
        {message: "Listen successfully deleted", success: true}
      else
        {errors: recording_listen.errors, success: false}
      end
    rescue ActiveRecord::RecordNotFound => e
      GraphQL::ExecutionError.new("Error: #{e.message}")
    end
  end
end
