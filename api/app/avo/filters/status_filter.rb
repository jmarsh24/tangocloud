class Avo::Filters::StatusFilter < Avo::Filters::BooleanFilter
  self.name = "Status Filter"

  def apply(request, query, value)
    statuses = value.select { |k, v| v }.keys
    query.where(status: statuses)
  end

  def options
    AudioFile.statuses
  end
end
