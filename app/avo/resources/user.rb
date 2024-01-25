# frozen_string_literal: true

class Avo::Resources::User < Avo::BaseResource
  self.includes = [:user_preference]
  self.search = {
    query: -> { query.search(params[:q]) }
  }
  self.title = :email

  def fields
    field :id, as: :id, only_on: :show
    field :admin, as: :boolean
    field :verified, as: :boolean, readonly: true
    field :avatar, as: :file, is_image: true, as_avatar: :rounded
    field :email, as: :text, disabled: -> { view == :edit }
    field :webauthn_id, as: :text, hide_on: :all
    field :playlists, as: :has_many, hide_on: :index
    field :tandas, as: :has_many, hide_on: :index
    field :first_name, as: :text
    field :last_name, as: :text
    field :user_setting, as: :has_one, hide_on: :index
    field :user_preference, as: :has_one, hide_on: :index
    field :subscription, as: :has_one, hide_on: :index
  end
end
