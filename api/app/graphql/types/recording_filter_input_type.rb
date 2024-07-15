module Types
  class RecordingFilterInputType < Types::BaseInputObject
    argument :orchestra_periods, [String], required: false
    argument :genres, [String], required: false
    argument :singers, [String], required: false
    argument :roles, [String], required: false
    argument :orchestra, String, required: false
  end
end
