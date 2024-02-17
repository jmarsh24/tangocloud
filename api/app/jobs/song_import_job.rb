class SongImportJob < ApplicationJob
  queue_as :import

  def perform(file:)
    SongImporter.new(file:).import
  end
end
