module Types
  class AudioFileType < Types::BaseObject
    field :id, ID, null: false
    field :filename, String, null: false

    has_one :digital_remaster
    has_one_attached :file
  end
end
