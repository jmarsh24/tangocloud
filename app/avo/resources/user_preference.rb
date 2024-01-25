# frozen_string_literal: true

class Avo::Resources::UserPreference < Avo::BaseResource
  self.includes = []

  def fields
    field :id, as: :id
    field :username, as: :text
    field :first_name, as: :text
    field :last_name, as: :text
    field :gender, as: :text
    field :birth_date, as: :text
    field :locale, as: :text
    field :user_id, as: :text
    field :avatar, as: :file
    field :user, as: :belongs_to
  end
end
