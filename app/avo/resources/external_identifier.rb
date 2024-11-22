class Avo::Resources::ExternalIdentifier < Avo::BaseResource
  self.includes = [:recording, :acr_cloud_recognition]

  def fields
    field :service_name, as: :text
    field :metadata, as: :code, language: "javascript" do
      if record.metadata.present?
        JSON.pretty_generate(record.metadata.as_json)
      end
    end
    field :recording, as: :belongs_to
    field :acr_cloud_recognition, as: :belongs_to
  end
end
