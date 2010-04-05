class BooleanQuestion < Question

  def self.data_type_description
    "Yes/No"
  end

  def sql_transform(column_name = '?')
    "CAST(#{column_name} AS CHAR)"
  end

  def format_data(data)
    %w(1 T t Y y).include?(data) unless data.blank?
  end
  
  def to_s(data)
    case format_data(data)
      when nil: ""
      when true: "Yes"
      else "No"
    end
  end
  
end
