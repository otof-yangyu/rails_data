require 'csv'
class CsvExportService
  attr_reader :sheet, :headers

  def initialize
    headers =
    config_table


  end


  def to_csv
    csv = ''
    csv << headers.to_csv
    self.table_items.each do |table_item|
      csv << table_item.fields.to_csv
    end
    csv
  end

  def csv_file_name
    "#{self.id}.csv"
  end

end