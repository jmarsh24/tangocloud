module Types
  class RecordingFilterInputType < Types::BaseInputObject
    argument :orchestra, [String], required: false
    argument :orchestra_periods, [String], required: false
    argument :roles, [String], required: false
    argument :singers, [String], required: false
    argument :year, [String], required: false
    argument :genre, [String], required: false
  end
end
