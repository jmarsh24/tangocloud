module Types
  class WaveformType < Types::BaseObject
    field :bits, Integer, null: false
    field :channels, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :data, [Float], null: false
    field :id, ID, null: false
    field :length, Integer, null: false
    field :sample_rate, Integer, null: false
    field :samples_per_pixel, Integer, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :version, Integer, null: false

    belongs_to :digital_remaster
    has_one_attached :image
  end
end
