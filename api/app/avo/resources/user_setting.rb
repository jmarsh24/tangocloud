class Avo::Resources::UserSetting < Avo::BaseResource
  self.includes = []
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :user_id, as: :text
    field :admin, as: :boolean
    field :user, as: :belongs_to
  end
end
