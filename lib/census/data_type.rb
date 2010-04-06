module Census
  class DataType
    attr_accessor :name
    attr_accessor :sql_transform
    attr_accessor :format_data
    attr_accessor :validate_data

    @@data_types = []

    def self.all
      @@data_types
    end
    
    def self.define(name, options = {})
      @@data_types << DataType.new(name, options)
    end
    
    def self.find(name)
      @@data_types.select {|dt| dt.name == name}.try(:first)
    end
    
    def initialize(name, options)
      @name = name
      @sql_transform  = options[:sql_transform] || lambda {|column_name| "#{column_name}"}
      @format_data    = options[:format_data]   || lambda {|data| data}
      @validate_data  = options[:validate_data] || lambda {|data| nil}
    end
    
    def to_s
      @name
    end
  end
end
