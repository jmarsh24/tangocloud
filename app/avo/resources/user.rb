# frozen_string_literal: true

class Avo::Resources::User < Avo::BaseResource
  self.includes = [:user_preference]
  self.search = {
    query: -> { query.search(params[:q]) }
  }
  self.title = :email

  def fields
    field :id, as: :id, only_on: :show
    field :avatar, as: :file, is_image: true, as_avatar: :rounded
    field :email, as: :text, readonly: true
    field :verified, as: :boolean, readonly: true
    field :webauthn_id, as: :text, only_on: :show
    field :action_auth_sessions, as: :has_many
    field :action_auth_webauthn_credentials, as: :has_many
    field :playlists, as: :has_many
    field :tandas, as: :has_many
    field :user_setting, as: :has_one
    field :user_preference, as: :has_one
    field :subscription, as: :has_one
  end
end
