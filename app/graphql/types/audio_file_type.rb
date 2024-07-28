module Types
  class AudioFileStatusEnum < Types::BaseEnum
    value "PENDING", value: "pending"
    value "PROCESSING", value: "processing"
    value "COMPLETED", value: "completed"
    value "FAILED", value: "failed"
  end

  class AudioFileType < Types::BaseObject
    field :error_message, String, null: true
    field :filename, String, null: false
    field :format, String, null: false
    field :id, ID, null: false
    field :status, AudioFileStatusEnum, null: false
    field :digital_remaster, Types::DigitalRemasterType, null: true

    has_one_attached :file
  end
end
