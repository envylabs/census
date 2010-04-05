class NumberQuestion < Question

  def self.data_type_description
    "Number"
  end

  def sql_transform(column_name = '?')
    "CAST(#{column_name} AS SIGNED INTEGER)"
  end

  def format_data(data)
    data.to_i unless data.blank?
  end
  
  def validate_data(data)
    "must be a number" unless data =~ /^\d*$/
  end

end
