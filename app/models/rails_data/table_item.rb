module RailsData::TableItem
  extend ActiveSupport::Concern
  included do
    attribute :fields, :string, array: true
    belongs_to :table_list, counter_cache: true
  end
  
end
