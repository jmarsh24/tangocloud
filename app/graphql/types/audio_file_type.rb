module Types
  class AudioFileType < Types::BaseObject
    field :error_message, String, null: true
    field :filename, String, null: false
    field :format, String, null: false
    field :id, ID, null: false

    enum_field :status
    belongs_to :digital_remaster
    has_one_attached :file
  end
end
