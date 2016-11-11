class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :assigned_properties, :favourite_properties]
  before_action :validate_user, only: [:edit, :update]
  before_action :set_featured_properties, only: [:agents, :show, :edit, :assigned_properties, :favourite_properties, :lawyers, :architects]
  before_action :authenticate_admin, only: [:destroy]
  before_action :set_params, only: [:show]
  before_action :pre_login_alerts, only: [:update]
  before_action :set_user_favourities, only: [:favourite_properties]
  before_action :set_favourited_params, only: [:show]
  before_action :build_email, only: [:agents, :lawyers, :architects]

  load_and_authorize_resource only: [:index, :new, :edit, :update, :create, :destroy, :agents, :lawyers, :architects]

  def index
    @users = User.subscribers

    respond_to do |format|
      format.html
      format.csv { render text: @users.to_csv }
    end
  end

  def show
    @user_properties = Property.perform_search(params)
    @array_of_property_fields = Property.property_fields_array(@user_properties)
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, flash: { success: 'Your profile was successfully updated.' }
    else
      render '/devise/registrations/edit'
    end
  end

  def destroy
    respond_to do |format|
      if @user.destroy
        format.html {
          flash[:success] = 'User was successfully destroyed'
          redirect_to referrer_path
        }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, flash: { error: 'User was not destroyed' } }
      end
    end
  end

  def agents
    @agents = User.includes(:attachment).ordered_agents.page(params[:page])
  end

  def lawyers
    @lawyers = User.includes(:attachment).ordered_lawyers.page(params[:page])
  end

  def architects
    @architects = User.includes(:attachment).ordered_architects.page(params[:page])
  end

  def assigned_properties
    params.merge!(agent_id: @user.id, state: Array(params[:state]))
    @user_properties = Property.perform_search(params)
    @array_of_property_fields = Property.property_fields_array(@user_properties)
    render 'show'
  end

  def favourite_properties
    params.merge!(state:  Array(params[:state]))
    @favourited = true
    @user_properties = Property.get_favourites(params)
    @array_of_property_fields = Property.property_fields_array(@user_properties)
    render 'show'
  end

  private

  def user_params
    params.require(:user).permit(:name, :home_phone_code, :home_phone_number,
                                 :mobile_phone_code, :mobile_phone_number, :terms_and_conditions,
                                 :uid, :provider, :oauth_token, :oauth_expires_at, :subscriber, :role,
                                 :agent_description, :fax_code, :fax_number, :city, :country, :address,
                                 :zip_code, :password, :password_confirmation,
                                  attachment_attributes: [:id, :image, :_destroy])
  end

  def set_user
    @user = User.find_by_id params[:id]
    return redirect_to :root, flash: { error: "User not found" } if @user.blank?
  end

  def validate_user
    return redirect_to :root, flash: { error: "You are not allowed to access this page" } unless @user == current_user
  end

  def authenticate_admin
    redirect_to :root, flash: { error: 'You are not authorized for this action' } unless current_user.admin?
  end

  def set_params
    state = params[:state].present? ? Array(params[:state]) : Property::REQUIRED_STATES
    if params[:favourited_type].present?
      params.merge!(favourited_user_id: @user.id, state: state)
    elsif params[:agent_id].present?
      params.merge!(agent_id: @user.id, state: state)
    else
      params.merge!(user_id: @user.id, state: state)
    end
  end

  def set_favourited_params
    if params[:favourited_type] == 'Property'
      @favourited = true
      set_user_favourities
    end
  end

  def build_email
    @email = Email.new
  end
end
