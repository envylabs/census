Census.configure do |config|
  # To restrict access to the census admin UI, specify a code snippet that
  # evaluates to true for anyone who should have access. By default, everyone
  # has access to the admin UI.
  #
  # config.admin_role = 'current_user.admin?'
end

#
# Define data types. All data is stored in the database as strings, and you can
# provide procs that will be used to convert from the stored strings to any data
# type you need.
#
# :sql_transform - should return a SQL fragment that will be used for comparing
#                  data when doing search queries
# :format_data   - is used to convert data from its string representation
# :validate_data - is used to validate form field submissions, and should return
#                  nil if the data is valid and an error message if it is invalid
#
Census::DataType.define("String")

Census::DataType.define(
  "Number",
  :sql_transform  => lambda {|column_name| "CAST(#{column_name} AS SIGNED INTEGER)"},
  :format_data    => lambda {|data| data.to_i unless data.blank? },
  :validate_data  => lambda {|data| "must be a number" unless data =~ /^\d*$/}
)
