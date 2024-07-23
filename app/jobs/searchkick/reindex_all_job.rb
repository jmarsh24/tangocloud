class Searchkick::ReindexAllJob < ApplicationJob
  queue_as :background

  def perform
    # eager load models to populate Searchkick.models
    if Rails.respond_to?(:autoloaders) && Rails.autoloaders.zeitwerk_enabled?
      # fix for https://github.com/rails/rails/issues/37006
      Zeitwerk::Loader.eager_load_all
    else
      Rails.application.eager_load!
    end

    Searchkick.models.each do |model|
      puts "Reindexing #{model.name}..."
      model.reindex
    end
    puts "Reindex complete"
  end
end
