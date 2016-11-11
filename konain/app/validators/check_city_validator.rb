class CheckCityValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    project = Project.find_by_id(value)
    return record.errors[attribute] << (options[:message] || "does not exist") if project.blank?
    record.errors[attribute] << (options[:message] || "is not valid for selected City") unless record.city == project.city
  end

end
