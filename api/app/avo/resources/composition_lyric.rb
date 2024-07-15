class Avo::Resources::CompositionLyric < Avo::BaseResource
  self.includes = [:composition, :lyric]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :composition, as: :belongs_to
    field :lyric, as: :belongs_to
  end
end
