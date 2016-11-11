class PropertiesController < ApplicationController

  before_action :authenticate_user!, only: [:edit, :new, :destroy]
  before_action :set_property, only: [:show, :edit, :update, :destroy, :validate_user]
  before_action :set_user_favourities, only: [:index, :show, :property_types, :home_page]
  before_action :set_featured_properties, only: [:new, :edit, :create, :update, :home_page]
  before_action :validate_property_type_subtype_feature, only: [:create, :update]
  before_action :set_property_type_sub_type_feature, only: [:create, :update]
  before_action :validate_user, only: [:show]
  before_action :set_home_page, only: [:home_page]
  before_action :set_ticker_content, only: [:home_page]
  before_action :set_sub_projects, only: [:show, :index, :new, :home_page]

  load_and_authorize_resource only: [:index, :show, :new, :edit, :update, :create, :destroy]

  def index
    @properties = Property.perform_search(params)
    @property_types = Property.fetch_all_types
    @array_of_property_fields = Property.property_fields_array(@properties)
  end

  def show
    gon.property_location = {"lat" => @sub_project.latitude, "lng" => @sub_project.longitude}
    gon.address = [@property.get_project.location, @property.get_project.city].join(", ")
    gon.country = "#{@property.project.country}"
    @attachments = @property.attachments
    @related_properties = @property.related_properties.first(Property::RELATED_PROPERTIES)
    @email = Email.new
    flash.now[:success] = "This property needs admin approval after that it will be available for public viewing." if @property.pending?
  end

  def new
    @property = Property.new
  end

  def edit
    @types     = Property::PROPERTY_TYPES[@property.category]
    @sub_types = Property::PROPERTY_SUB_TYPES[@property.property_type]
    @features = Property::PROPERTY_FEATURES[@property.property_type]
    @city     = @property.city
    @sub_projects = SubProject.projects_by_city(@city).pluck(:title, :id)
    params[:property] = { property_type: @property.property_type,
                          property_sub_type: @property.property_sub_type,
                          property_features: @property.property_features
                        }
  end

  def create
    @property = current_user.properties.new(property_params)
    respond_to do |format|
      if @property.save

        format.html { redirect_to @property, flash: { success: 'Your uploaded property is pending approval from Admin.' } }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @property.state = "pending"
    @sub_projects = SubProject.projects_by_city(@property.city).pluck(:title, :id)
    respond_to do |format|
      if @property.update(property_params)
        format.html {
          flash[:success] = 'Your updated property is pending approval from Admin.'
          if session[:redirect_url].to_s.include?('/properties')
            redirect_to @property
          else
            redirect_to redirect_url_path
          end
        }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit, flash: { error: 'Property was not updated.' } }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @property.destroy
        format.html {
          flash[:success] = 'Property was successfully destroyed'
          if request.referrer.include?('/properties/')
            redirect_to :root
          else
            redirect_to referrer_path
          end
        }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, flash: { error: 'Property was not destroyed' } }
      end
    end
  end

  def fetch_property_type
    @types = Property::PROPERTY_TYPES[params[:category]]
  end

  def fetch_property_sub_type
    @sub_types = Property::PROPERTY_SUB_TYPES[params[:property_type]]
  end

  def fetch_property_features
    @features = Property::PROPERTY_FEATURES[params[:property_type]]
  end

  def property_types
    @properties = Property.perform_search(params)
    @property_types = Property.fetch_all_types
    @array_of_property_fields = Property.property_fields_array(@properties)
    render "index"
  end

  def home_page
    search_params = params.merge(per_page: Property::HOME_FEATURED, home_listing: true, order: 'featured_at DESC')
    @featured_properties = Property.perform_search(search_params)
    @projects = Project.includes(:attachments).ordered
    @property_types = Property.fetch_all_types
  end

  private
  def set_property
    @property = Property.find_by_id(params[:id])
    return redirect_to :root, flash: { error: "Property was not found." } if @property.blank?
    @sub_project = @property.sub_project.present? ? @property.sub_project : @property.project
  end

  def validate_property_type_subtype_feature
    params[:property][:property_type] = ""      unless params[:property].key?(:property_type)
    params[:property][:property_sub_type] = ""  unless params[:property].key?(:property_sub_type)
    params[:property][:property_features] = ""   unless params[:property].key?(:property_features)
  end

  def set_property_type_sub_type_feature
    @types     = Property::PROPERTY_TYPES[params[:property][:category]]
    @sub_types = Property::PROPERTY_SUB_TYPES[params[:property][:property_type]]
    @features  = Property::PROPERTY_FEATURES[params[:property][:property_type]]
  end

  def validate_user
    return redirect_to :root, flash: { error: "Property is no longer available" } if @property.closed?
    return if @property.approved?
    unless user_signed_in? && @property.user_authorized?(current_user)
      return redirect_to :root, flash: { error: "You are not allowed to access this page" }
    end
  end

  def set_ticker_content
    setting = Setting.selected_setting("News Ticker")
    if setting.present?
      @ticker_content = Ticker.all
    else
      @recent_properties = Property.perform_search(params)
    end
  end

  def property_params
    params[:property][:property_features] = [] if params[:property][:property_features].blank?
    params.require(:property).permit(:category, :city, :title, :description, :price, :land_area,
                                     :area_unit, :bedroom_count, :bathroom_count, :longitude, :latitude, :sub_project_id,
                                     :property_type, :property_sub_type, :project_id, :state,
                                     property_features: [], attachments_attributes: [:id, :image, :_destroy])
  end

  def set_sub_projects
    @sub_projects = SubProject.ordered.pluck(:title, :id)
  end

end
