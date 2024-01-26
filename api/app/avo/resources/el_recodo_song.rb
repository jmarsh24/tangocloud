# frozen_string_literal: true

class Avo::Resources::ElRecodoSong < Avo::BaseResource
  self.title = "El Recodo Songs"
  self.includes = []
  self.index_query = -> {
    query.order(music_id: :asc)
  }
  self.search = {
    query: -> { query.search(params[:q]) },
    item: -> do
      {
        title: "#{record.title} - #{record&.orchestra&.titleize_name} - #{record&.singer} - #{record&.style&.titleize_name}"
      }
    end
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :ert_number, as: :number, readonly: true, sortable: true, only_on: :show
    field :music_id, as: :number, readonly: true, sortable: true
    field :external, as: :text do
      link_to "Link", "https://www.el-recodo.com/music?id=#{record.music_id}", target: "_blank", rel: "noopener"
    end
    field :title, as: :text, readonly: true, format_using: -> { value&.truncate 28 }
    field :orchestra, as: :text, readonly: true, format_using: -> { value&.titleize_name }
    field :date, as: :date, readonly: true, sortable: true
    field :style, as: :text, readonly: true, format_using: -> { value&.titleize&.truncate 8 }
    field :singer, as: :text, readonly: true, format_using: -> { value&.truncate 24 }
    field :author, as: :text, readonly: true, format_using: -> { value&.truncate 24 }
    field :composer, as: :text, readonly: true, format_using: -> { value&.titleize_name }
    field :soloist, as: :text, readonly: true, format_using: -> { value&.titleize_name }
    field :director, as: :text, readonly: true, format_using: -> { value&.titleize_name }
    field :record_label, as: :text, readonly: true, only_on: :show
    field :lyrics, as: :textarea, readonly: true, only_on: :show
    field :synced_at, as: :date_time, readonly: true, only_on: :show
    field :page_updated_at, as: :date_time, readonly: true, only_on: :show
  end

  def actions
    action Avo::Actions::ExportCsv
  end
end
