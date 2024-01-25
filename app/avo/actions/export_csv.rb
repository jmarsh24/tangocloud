# frozen_string_literal: true

class Avo::Actions::ExportCsv < Avo::BaseAction
  self.name = "Export csv"
  self.no_confirmation = true
  self.standalone = true

  def handle(**args)
    records, resource = args.values_at(:records, :resource)
    records = resource.model_class.all if records.blank?

    attributes = get_attributes records.first

    # Generate CSV, specify semicolon as column separator
    file = CSV.generate(headers: true, col_sep: ";", force_quotes: true) do |csv|
      csv << attributes

      records.each do |record|
        csv << attributes.map do |attr|
          value = record.send(attr)
          process_value(value)  # Process values to ensure proper CSV formatting
        end
      end
    end

    file_name = "#{resource.plural_name}_#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.csv"
    download file, file_name
  end

  def get_attributes(record)
    # return ["id", "created_at"] # uncomment this and fill in for custom model properties

    record.class.columns_hash.keys
  end
end
