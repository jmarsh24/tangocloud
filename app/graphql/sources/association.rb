class Sources::Association < GraphQL::Dataloader::Source
  def initialize(model_class, association_name, scope)
    @model_class = model_class
    @association_name = association_name
    @scope = scope
    validate
  end

  def fetch(records)
    ::ActiveRecord::Associations::Preloader.new(records:, associations: @association_name, scope: @scope).call
    records.map { |record| record.public_send(@association_name) }
  end

  private

  def validate
    raise ArgumentError, "No association #{@association_name} on #{@model_class}" unless @model_class.reflect_on_association(@association_name)
  end
end
