module UsersHelper

  def terms_and_conditions
    "I have read and accepted Konain Marketing Online #{link_to 'Terms and Conditions', '/terms_and_conditions', target: "blank" }".html_safe
  end

  def resource_name
    :user
  end

  def resource
    @resource || @user || User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def agent_image(agent)
    attachment = agent.attachment
    attachment.try(:image).try(:url, :featured) || 'no_agent_image_agent.jpg'
  end

  def user_image(user)
    attachment = user.attachment
    attachment.try(:image).try(:url, :featured) || 'no_agent_image_user.jpg'
  end

  def agents_image(agent)
    attachment = agent.attachment
    attachment.try(:image).try(:url, :featured) || 'no_agent_image_all_agents.jpg'
  end

  def can_edit?(user)
    user_signed_in? && user.id == current_user.id
  end

  def display_user_role(user)
    if user.lawyer?
      "Lawyer Info"
    elsif user.agent?
      "Agent Info"
    else
      "Seller Info"
    end
  end

  def included_in?(url)
    url.include?('/assigned_properties') || url.include?('/favourite_properties')
  end

  def add_data_to_params(id, state, category, favourited_type=nil, agent_id=nil)
    {
      id: id,
      state: state,
      category: category,
      favourited_type: favourited_type,
      agent_id: agent_id,
    }
  end

  def active_filter_tab(params, action)
    return "active" if params[:action] == action
  end

  def page_info(users, role)
    return ['No', role.pluralize.humanize, 'found'].join(' ') unless users.present?
    return ['Showing', users.length, [users.last.role, '(s)'].join].join(' ')
  end
end
