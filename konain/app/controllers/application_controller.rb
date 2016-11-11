class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :store_current_location, unless: :devise_controller?
  before_action :fetch_all_property_types

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: "Access denied"
  end

  rescue_from ActionController::InvalidAuthenticityToken do
   redirect_to :root
  end


  def authenticate_admin_user!
    if user_signed_in? && !current_user.is_admin_or_agent?
      flash[:alert] = "You are not authorized to access this resource!"
      redirect_to root_path
    end
  end

  def access_denied(exception)
    if user_signed_in? && current_user.is_admin_or_agent?
      redirect_to admin_dashboard_path, alert: exception.message
    else
      redirect_to root_path, alert: exception.message
    end
  end

  def after_sign_in_path_for(resource)
    if current_user.admin?
      '/admin'
    else
      session["user_return_to"] || root_path
    end
  end

  def set_user_favourities
    @favourities = current_user.favourite_properties.pluck(:id) if current_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :home_phone_code, :home_phone_number,
                                       :mobile_phone_code, :mobile_phone_number, :terms_and_conditions,
                                       :uid, :provider, :oauth_token, :oauth_expires_at, :subscriber, :role,
                                       :agent_description, :fax_code, :fax_number, :city, :country, :address,
                                       :zip_code, attachment_attributes: [:id, :image, :_destroy]])
  end

  def set_featured_properties
    @properties = Property.includes(:attachments).ordered_featured_properties.first(Property::FEATURED)
  end

  def redirect_url_path
    session[:redirect_url] || root_path
  end

  def referrer_path
    request.referrer || root_path
  end

  private

  def store_current_location
    store_location_for(:user, request.url)
  end

  def set_home_page
    @home_page = true
  end

  def pre_login_alerts
    @pre_login = true
  end

  def fetch_all_property_types
    @all_property_types = Property.fetch_all_types
  end

end
