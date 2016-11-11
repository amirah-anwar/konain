class CheckProjectValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    sub_project = SubProject.find_by_id(value)
    record.errors[attribute] << (options[:message] || "is not valid for selected Project") if sub_project.present? && record.project_id != sub_project.project_id
  end

end
