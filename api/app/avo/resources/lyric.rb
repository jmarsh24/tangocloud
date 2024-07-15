class Avo::Resources::Lyric < Avo::BaseResource
  self.includes = [:composition]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :locale, as: :text
    field :text, as: :textarea, format_using: -> do
      simple_format(value)
    end
    field :composition, as: :belongs_to
  end
end
