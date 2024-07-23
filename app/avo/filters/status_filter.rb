class Avo::Filters::StatusFilter < Avo::Filters::BooleanFilter
  self.name = "Status Filter"

  def apply(request, query, value)
    statuses = value.select { |k, v| v }.keys
    query.where(status: statuses)
  end

  def options
    AudioFile.statuses
  end

  def default
    {
      pending: true,
      processing: true,
      completed: true,
      failed: true
    }
  end
end
