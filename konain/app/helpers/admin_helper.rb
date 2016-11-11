module AdminHelper

  def render_price(amount)
    number_to_units(amount.to_i)
  end

  def property_cover_image(property)
    attachments = property.attachments
    picture = attachments.first
    picture.try(:image).try(:url, :index) || 'no_image_index.png'
  end

  def property_preview_image(attachment)
    if attachment.object.image.exists?
      image_tag(attachment.object.image.url(:index), class: "image-preview-size")
    else
      attachment.template.content_tag(:span, "", class: "target")
    end
  end

  def user_profile_image(attachment)
    attachment.present? ? image_tag(attachment.image.url(:index), class: 'dash-property-image') : content_tag(:span, "No Image Yet")
  end

  def user_preview_image(attachment)
    if attachment.object.image.exists?
      image_tag(attachment.object.image.url(:index), class: "image-preview-size")
    else
      attachment.template.content_tag(:span, "", class: "target")
    end
  end

  def preview_agent_value(user)
    user.agent? ? "yes" : "no"
  end

  def find_agent(email)
    User.find(email.agent_id)
  end

  def project_properties_listing(project)
    project.properties.collect{ |property| content_tag(:li, link_to(property.title, admin_property_path(property.id))) }
  end

  def projects_options
    Project.ordered.map{ |project| [[project.title,project.city].join(", "), project.id] }
  end

  def assigned_properties_listing(user)
    properties = Property.assigned_properties(user)
    properties.collect{ |property| content_tag(:li, link_to(property.title, admin_property_path(property.id))) }
  end

  def recent_assigned_properties_listing(user)
    assigned_properties_listing(user).last(10)
  end

  def banner_image(banner)
    if banner.image.exists?
      image_tag(banner.image.url(:thumb))
    else
      image_tag(Banner::DEFAULT_BANNER_URL, class: "banner-size")
    end
  end

  def check_image_page(banner, banner_size)
    if banner.image.exists?
      image_tag(banner.image.url(banner_size), class: "image-preview-size")
    else
      content_tag(:span, "", class: "target")
      image_tag(Banner::DEFAULT_BANNER_URL, class: "image-preview-size")
    end
  end

  def banner_image_preview(banner)
    if banner.home_page?
      check_image_page(banner, :extra_large)
    else
      check_image_page(banner, :large)
    end
  end

  def custom_page_banner_image(image)
    return image_tag(Banner::DEFAULT_BANNER_URL, class: "banner-size") if image.blank?

    if image.exists?
      image_tag(image.url(:thumb))
    else
      image_tag(Banner::DEFAULT_BANNER_URL, class: "banner-size")
    end
  end

  def custom_page_banner_image_preview(banner)
    if banner.object.image.exists?
      image_tag(banner.object.image.url(:large), class: "image-preview-size")
    else
      content_tag(:span, "", class: "target")
      image_tag(Banner::DEFAULT_BANNER_URL, class: "image-preview-size")
    end
  end

  def closed_at_class(property)
    property.closed_at.present? ? "" : "status_tag yes"
  end

  def sub_projects_titleize(project)
    project.sub_projects.pluck(:title).map(&:titleize).join(', ')
  end

  def link_to_project(sub_project)
    link_to sub_project.project_title, admin_project_path(sub_project.project)
  end

  def user_roles
    User::ROLES.collect { |role| [titleize(role), role] }
  end
end
