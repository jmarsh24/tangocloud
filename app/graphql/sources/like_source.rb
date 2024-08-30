module Sources
  class LikeSource < GraphQL::Dataloader::Source
    def initialize(user)
      @user = user
    end

    def fetch(recording_ids)
      likes = Like.where(likeable_type: "Recording", likeable_id: recording_ids, user: @user)
      recording_ids.map { |id| likes.any? { |like| like.likeable_id == id } }
    end
  end
end
