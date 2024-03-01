class Sources::Preload < GraphQL::Dataloader::Source
  def initialize(*associations)
    @associations = associations
  end

  def result_key_for(record)
    record.object_id # We pass in instances of ActiveRecord models and want to preload for each one, so we don't want to deduplicate them by id
  end

  def fetch(records)
    ::ActiveRecord::Associations::Preloader.new(records:, associations: @associations).call
    records
  end
end
