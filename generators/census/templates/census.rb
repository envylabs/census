Census::DataType.define("String")

Census::DataType.define(
  "Number",
  :sql_transform  => lambda {|column_name| "CAST(#{column_name} AS SIGNED INTEGER)"},
  :format_data    => lambda {|data| data.to_i unless data.blank? },
  :validate_data  => lambda {|data| "must be a number" unless data =~ /^\d*$/}
)

Census::DataType.define(
  "Yes/No",
  :sql_transform  => lambda {|column_name| "CAST(#{column_name} AS CHAR)"},
  :format_data    => lambda {|data| %w(1 T t Y y).include?(data) unless data.blank? }
)
