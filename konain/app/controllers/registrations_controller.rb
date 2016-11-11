class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create]
  before_action :set_featured_properties, only: [:edit, :update]
  before_action :initialize_attachment, only: [:edit]
  before_action :pre_login_alerts, only: [:update]

  protected

    def after_update_path_for(resource)
      user_path(resource)
    end

  private

  def check_captcha
    if verify_recaptcha
      true
    else
      flash.now[:alert] = "Please mark the recaptcha box checked"
      flash.delete :recaptcha_error
      self.resource = resource_class.new sign_up_params
      respond_with_navigational(resource) { render :new }
    end
  end

  def initialize_attachment
    if @user.attachment.blank?
      @user.build_attachment
    end
  end
end
