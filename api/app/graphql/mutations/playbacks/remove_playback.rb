module Mutations::Playbacks
  class RemovePlayback < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false
    field :success, Boolean, null: false
    field :errors, [String], null: true

    def resolve(id:)
      playback = Playback.find(id)

      if playback.destroy
        {message: "playback successfully deleted", success: true}
      else
        {errors: playback.errors, success: false}
      end
    rescue ActiveRecord::RecordNotFound => e
      {errors: [e.message], success: false}
    end
  end
end
