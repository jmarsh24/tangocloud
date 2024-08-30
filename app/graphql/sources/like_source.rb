module Sources
  class LikeSource < GraphQL::Dataloader::Source
    def initialize(user:, likeable_type:)
      @user = user
      @likeable_type = likeable_type
    end

    def fetch(likeable_ids)
      raise "Expected @user to be a User, got #{@user.class.name}" unless @user.is_a?(User)

      likes = Like.where(likeable_type: @likeable_type, likeable_id: likeable_ids, user: @user).pluck(:likeable_id)

      likeable_ids.map { likes.include?(_1) }
    end
  end
end
