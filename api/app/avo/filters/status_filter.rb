class Avo::Filters::StatusFilter < Avo::Filters::SelectFilter
  self.name = "Status Filter"

  def apply(request, query, value)
    query.where(status: value)
  end

  def options
    AudioFile.statuses
  end
end
