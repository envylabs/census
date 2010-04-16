Census.configure do |config|
  # To restrict access to the census admin UI, specify a code snippet that
  # evaluates to true for anyone who should have access. By default, everyone
  # has access to the admin UI.
  #
  # config.admin_role = 'current_user.admin?'
end

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
