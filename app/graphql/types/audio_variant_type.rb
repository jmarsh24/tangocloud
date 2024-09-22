module Types
  class AudioVariantType < Types::BaseObject
    field :bit_rate, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :format, String, null: false
    field :id, ID, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :url, String, null: false

    belongs_to :digital_remaster

    def url
      Rails.application.routes.url_helpers.api_audio_variant_url(object)
    end
  end
end
