# frozen_string_literal: true

class Avo::Resources::ElRecodoSong < Avo::BaseResource
  self.includes = []
  self.index_query = -> {
    query.order(music_id: :asc)
  }
  self.search = {
    query: -> { query.search(params[:q]) },
    item: -> do
      {
        title: "#{record.title} - #{record.orchestra.titleize_name} - #{record.singer} - #{record.style.titleize_name}"
      }
    end
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :ert_number, as: :number, readonly: true, sortable: true, only_on: :show
    field :music_id, as: :number, readonly: true, sortable: true
    field :title, as: :text, readonly: true
    field :orchestra, as: :text, readonly: true
    field :singer, as: :text, readonly: true
    field :date, as: :date, readonly: true, sortable: true
    field :style, as: :text, readonly: true
    field :composer, as: :text, readonly: true
    field :author, as: :text, readonly: true
    field :soloist, as: :text, readonly: true
    field :director, as: :text, readonly: true
    field :label, as: :text, readonly: true
    field :lyrics, as: :textarea, readonly: true, only_on: :show
    field :synced_at, as: :date_time, readonly: true
    field :page_updated_at, as: :date_time, readonly: true
  end

  def actions
    action Avo::Actions::ExportCsv
  end
end
