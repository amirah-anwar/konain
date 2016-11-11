class PropertyFeaturesInclusionValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.blank?
    return record.errors[attribute] << (options[:message] || "do not exist for selected Property Type") unless Property::PROPERTY_FEATURES.keys.include?(record.property_type)
    features_check_array = record.property_features.map{ |feature| Property::PROPERTY_FEATURES[record.property_type].include?(feature) }
    record.errors[attribute] << (options[:message] || "are not valid for selected Property Type") if features_check_array.include?(false)
  end

end
