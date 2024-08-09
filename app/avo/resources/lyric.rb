class Avo::Resources::Lyric < Avo::BaseResource
  self.includes = [:composition, :composition_lyric, :language]
  self.title = -> {
    ActionView::Base.full_sanitizer.sanitize(record.text).truncate 60
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :text, as: :textarea, format_using: -> do
      simple_format(value)
    end
    field :composition_lyric, as: :has_one, hide_on: :index
    field :composition, as: :has_one
    field :language, as: :belongs_to
  end
end
