class Avo::Resources::ExternalIdentifier < Avo::BaseResource
  self.includes = [:recording, :acr_cloud_recognition]

  def fields
    field :service_name, as: :text
    field :metadata, as: :text, hide_on: :index
    field :recording, as: :belongs_to
    field :acr_cloud_recognition, as: :belongs_to
  end
end
