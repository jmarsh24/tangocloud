module Types
  class RecordingOrderFieldEnumType < Types::BaseEnum
    value "TITLE", "Sort by title", value: "title"
    value "ORCHESTRA", "Sort by orchestra", value: "orchestra"
    value "SINGERS", "Sort by singers", value: "singers"
    value "GENRE", "Sort by genre", value: "genre"
    value "RECORDED_DATE", "Sort by recorded date", value: "recorded_date"
    value "PLAYBACKS_COUNT", "Sort by playbacks count", value: "playbacks_count"
    value "RECORDING_TYPE", "Sort by recording type", value: "recording_type"
    value "CREATED_AT", "Sort by created date", value: "created_at"
    value "UPDATED_AT", "Sort by updated date", value: "updated_at"
    value "RECORD_LABEL", "Sort by record label", value: "record_label"
    value "TIME_PERIOD", "Sort by time period", value: "time_period"
  end
end
