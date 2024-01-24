# frozen_string_literal: true

class Avo::Actions::ExportCsv < Avo::BaseAction
  self.name = "Export CSV"
  self.may_download_file = true

  def handle(models:, resource:, fields:, **)
    columns = models.first.class.columns_hash.keys
    # Uncomment below to use the user-selected fields
    # columns = get_columns_from_fields(fields)

    return error "No record selected" if models.blank?

    file = CSV.generate(headers: true) do |csv|
      csv << columns

      models.each do |record|
        csv << columns.map do |attr|
          record.send(attr)
        end
      end
    end

    download file, "#{resource.plural_name}.csv"
  end

  def get_columns_from_fields(fields)
    fields.select { |key, value| value }.keys
  end
end
