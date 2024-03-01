module Types
  class WaveformType < Types::BaseObject
    field :id, ID, null: false
    field :version, Integer, null: false
    field :channels, Integer, null: false
    field :sample_rate, Integer, null: false
    field :samples_per_pixel, Integer, null: false
    field :bits, Integer, null: false
    field :length, Integer, null: false
    field :data, [Float], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :image_url, String, null: true

    def image_url
      dataloader.with(Sources::Preload, image_attachment: :blob).load(object)
    end

    belongs_to :audio_transfer
  end
end
