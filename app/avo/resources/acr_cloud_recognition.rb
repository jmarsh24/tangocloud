class Avo::Resources::AcrCloudRecognition < Avo::BaseResource
  self.includes = [:digital_remaster]

  def fields
    field :digital_remaster, as: :belongs_to
    field :status, as: :text
    field :metadata, as: :text
  end
end
