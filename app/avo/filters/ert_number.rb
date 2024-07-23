class Avo::Filters::ErtNumber < Avo::Filters::TextFilter
  self.name = "Ert Number"
  self.button_label = "Filter by ERT Number"
  self.visible = -> do
    true
  end

  def apply(request, query, value)
    query.where(ert_number: value)
  end
end
