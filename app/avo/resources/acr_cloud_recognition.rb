class Avo::Resources::AcrCloudRecognition < Avo::BaseResource
  self.includes = [:digital_remaster]

  def fields
    field :digital_remaster, as: :belongs_to
    field :status, as: :text
    field :error_code, as: :text
    field :error_message, as: :text
    field :metadata, as: :code, language: "javascript" do
      if record.metadata.present?
        JSON.pretty_generate(record.metadata.as_json)
      end
    end
  end

  def filters
    filter Avo::Filters::StatusFilter
  end
end
