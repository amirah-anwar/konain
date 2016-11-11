module PropertiesHelper

  def is_owner?(property)
    current_user == property.user
  end

  def render_price(amount)
    number_to_units(amount.to_i)
  end

  def home_projects_image(project)
    attachments = project.attachments
    picture = attachments.first
    picture.try(:image).try(:url, :related) || 'no_image_home_projects.png'
  end

  def map_path(property)
    "http://maps.google.com/maps/api/staticmap?size=450x300&sensor=false&zoom=16&markers=#{property.latitude}%2C#{property.longitude}"
  end

  def category(property)
    property.category == 'Sale' ? "On #{property.category}" : "For #{property.category}"
  end

  def catergory_class(property)
    property.category == 'Sale' ? "status-35-sale" : "status-35-rent"
  end

  def catergory_text_class(property)
    property.category == 'Sale' ? "status-35-text-sale" : "status-35-text-rent"
  end

  def active(option, category=nil)
    return "active" if category.blank? || option == "All"
    return "active" if category == option
  end

  def add_category_to_params(category)
    {
      project_id: params[:project_id],
      city: params[:city],
      bedroom_count: params[:bedroom_count],
      bathroom_count: params[:bathroom_count],
      min_price: params[:min_price],
      max_price: params[:max_price],
      property_type: params[:property_type],
      category: category,
    }
  end

  def add_category_property_type_to_params(category, property_type)
    {
      property_type: property_type,
      category: category,
    }
  end

  def area_units_abbreviation(area_unit)
    {
      'Square Feet' => 'sq ft',
      'Square Yards' => 'sq yd',
      'Square Meters' => 'sq m',
      'Marla' => 'M',
      'Kanal' => 'K',
    }[area_unit]
  end

  def set_redirect_url
    session[:redirect_url] = request.referrer
  end

  def category_field?(params)
    params[:controller] == 'users' && params[:action] == 'show'
  end

  def check_property_type?(type, params)
    return false if params[:property].blank?
    return false if params[:property][:property_type].blank?
    return false if type.blank?
    return true if params[:property][:property_type] == type
  end

  def check_property_sub_type?(sub_type, params)
    return false if params[:property].blank?
    return false if params[:property][:property_sub_type].blank?
    return false if sub_type.blank?
    return true if params[:property][:property_sub_type] == sub_type
  end

  def check_property_features?(feature, params)
    return false if params[:property].blank?
    return false if params[:property][:property_features].blank?
    return false if feature.blank?
    params[:property][:property_features]
    return true if params[:property][:property_features].include?(feature)
  end

  def display_property_type(property)
    [property.property_sub_type, property.property_type].join(" ")
  end

  def projects_list
    Project.ordered.map{ |project| [project.title, project.id] }
  end

  def sub_projects_list
    SubProject.ordered.map{ |sub_project| [sub_project.title, sub_project.id] }
  end

  def selected_projects_list(city)
    if city.present?
      Project.projects_by_city(city).map { |project| [project.title, project.id] }
    else
      projects_list
    end
  end

  def display_title_location(property)
    [property.title, property.location].join(", ")
  end

  def space_to_underscore(name)
    name.gsub(" ","_")
  end

  def property_type_active?(type, property_type)
    return "active" if property_type.blank? && type == "All"
    return "active" if property_type == type
  end

  def project(property)
    property.sub_project.present? ? property.sub_project : property.project
  end

  def property_address(property)
    [project(property).location, property.city, "Pakistan"].join(", ")
  end

  def select_property_sub_project(property, sub_projects, form_object)
    return form_object.select :sub_project_id, options_for_select(sub_projects_list), { include_blank: 'Select Phase' } unless property.persisted?
    if property.sub_project.present?
      form_object.select :sub_project_id, options_for_select(sub_projects, selected: property.sub_project.id) , { include_blank: 'Select Phase' }
    else
      form_object.select :sub_project_id, {}, { include_blank: 'No Phase' }
    end
  end

end
