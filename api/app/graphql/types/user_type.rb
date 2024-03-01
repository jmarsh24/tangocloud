module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :password_digest, String, null: false
    field :verified, Boolean, null: false
    field :provider, String
    field :uid, String
    field :username, String, null: false
    field :name, String, null: false
    field :first_name, String
    field :last_name, String
    field :admin, Boolean, null: false
    field :avatar_url, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def avatar_url
      if object.avatar.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.avatar)
      else
        "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(object.email)}?d=identicon"
      end
    end

    field :sessions, [SessionType], null: false

    def sessions
      dataloader.with(Sources::Preload, :sessions).load(object)
    end

    field :events, [EventType], null: false

    def events
      dataloader.with(Sources::Preload, :events).load(object)
    end
  end
end
