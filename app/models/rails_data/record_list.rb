module RailsData::RecordList
  extend ActiveSupport::Concern
  included do
    attribute :columns, :json
    attribute :parameters, :json
    belongs_to :data_list

    default_scope -> { order(id: :desc) }
  end
  
  def run
    to_table
  end

  def to_table
    initialize_table
    self.to_table_items
    self.done = true
    self.save
  end

  def initialize_table
    @config_table = data_list.config_table
    @record = @config_table.record.call(converted_parameters)
    @config_table
  end

  def converted_parameters
    param = {}
    parameters.each do |k, v|
      param.merge! k.to_sym => v.send(RailsData.config.mapping[data_list.parameters[k].to_sym][:output])
    end
    param
  end

  def to_table_items
    self.columns = field_result(@record)
  end

  def field_result(object)
    results = {}
    @config_table.columns.each do |key, column|
      if column[:field].arity == 1
        results[key] = column[:field].call(object)
      else
        results[key] = nil
      end
    end

    results
  end

  def to_xlsx
    @config_excel = data_list.config_excel.new(self.columns)
    @config_excel.render
  end

  def to_pdf
    @config_pdf ||= data_list.config_pdf.new(self.columns)
    @config_pdf.render
  end

  def xlsx_file_name
    @config_excel.file_name || "#{self.id}.xlsx"
  end

  def file_name(format)
    name = self.id || 'example'
    "#{name}.#{format}"
  end

end
