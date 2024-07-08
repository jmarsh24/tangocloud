class Avo::Resources::OrchestraPeriod < Avo::BaseResource
  self.includes = [:orchestra]

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :start_date, as: :date
    field :end_date, as: :date
    field :orchestra, as: :belongs_to
  end
end
