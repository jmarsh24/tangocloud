module Mutations::Playlist
  class DeletePlaylist < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false

    def resolve(id:)
      playlist = Playlist.find(id)

      if playlist.destroy
        {message: "Playlist successfully deleted"}
      else
        {errors: playlist.errors}
      end
    rescue ActiveRecord::RecordNotFound => e
      GraphQL::ExecutionError.new("Error: #{e.message}")
    end
  end
end
