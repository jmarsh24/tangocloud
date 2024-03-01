class Sources::Record < GraphQL::Dataloader::Source
  def initialize(model_class, column: model_class.primary_key, where: nil, includes: nil, scope: nil)
    @model_class = model_class
    @column = column.to_s
    @includes = includes
    @scope = scope
  end

  def fetch(ids)
    records = query(ids)
    ids.map { |id| records.find { |r| r.id == id } }
  end

  private

  def query(keys)
    scope = @model_class
    scope = scope.where(@where) if @where
    scope = scope.includes(@includes) if @includes
    scope = scope.instance_exec(&@scope) if @scope.is_a?(Proc)
    scope = scope.public_send(@scope) if @scope.is_a?(Symbol)
    scope.where(@column => keys)
  end
end
