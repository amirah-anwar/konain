ActiveAdmin.register Property do

  filter :state, as: :select, collection: proc { Property::STATES.map{ |state| [state.titleize, state] } }
  filter :user, as: :select, collection: proc { User.all }
  filter :agent, as: :select, collection: proc { User.ordered_agents }
  filter :category, as: :select, collection: proc { Property::CATEGORY }
  filter :city, as: :select, collection: proc { Property::CITIES }
  filter :project_id, as: :select, collection: proc { projects_options }
  filter :sub_project_id, as: :select, collection: proc { sub_projects_list }
  filter :property_type, as: :select, collection: proc {  Property::PROPERTY_TYPES }
  filter :property_sub_type, as: :select, collection: proc {  Property::PROPERTY_SUB_TYPES }
  filter :price, as: :numeric
  filter :land_area, as: :numeric
  filter :area_unit, as: :select, collection: proc { Property::UNITS }
  filter :bedroom_count, as: :numeric
  filter :bathroom_count, as: :numeric
  filter :featured, as: :check_boxes
  filter :home_listing, as: :check_boxes
  filter :closed_at, label: 'Property Deal closed at'
  filter :end_price, as: :numeric, label: 'Property Deal Final Price'
  filter :created_at

  controller do
    before_action :validate_property, only: [:show, :edit, :update, :destroy, :set_property]
    before_action :set_property, only: [:edit]
    before_action :set_params, only: [:create, :update]

    def scoped_collection
      super.includes [:attachments, :project, :user]
    end

    def fetch_types
      @selected_value = params[:fetch_type]
      @types = Property::PROPERTY_TYPES[params[:category]]
      respond_to do |format|
        format.js { render partial: "property_types", locals: { types: @types, selected_value: @selected_value } }
      end
    end

    def fetch_sub_types
      @selected_value = params[:fetch_sub_type]
      @sub_types = Property::PROPERTY_SUB_TYPES[params[:property_type]]
      respond_to do |format|
        format.js { render partial: "property_sub_types", locals: { sub_types: @sub_types, selected_value: @selected_value } }
      end
    end

    def fetch_features
      @selected_values = params[:fetch_features].to_s.split(",")
      @features = Property::PROPERTY_FEATURES[params[:property_type]]
      respond_to do |format|
        format.js { render partial: "property_features", locals: { features: @features, selected_values: @selected_values } }
      end
    end

    def fetch_sub_projects
      @selected_value = params[:id]
      @project = Project.find_by_id(params[:id])
      @sub_projects = @project.sub_projects.ordered.pluck(:title, :id) if @project.sub_projects.exists?
      respond_to do |format|
        format.js { render 'property_sub_projects', locals: { selected_value: @selected_value } }
      end
    end

    def create
      super do |format|
        params[:property].delete('attachments_attributes') if resource.invalid?
      end
    end

    def update
      super do |format|
        params[:property].delete('attachments_attributes') if resource.invalid?
      end
    end

    private

    def set_property
      gon.property = @property
    end

    def set_params
      gon.property = params[:property]
    end

    def validate_property
      return redirect_to root_path, flash: { error: "You need to sign in" } unless user_signed_in?
      @property = Property.find_by_id params[:id]
      return redirect_to admin_properties_path, flash: { error: "Property was not found" } if @property.blank?
    end
  end

  collection_action :property_report, method: :get do
    properties = Property.ransack(params[:q]).result
    csv = Property.export_csv(properties)
    send_data csv.encode('Windows-1251'), type: 'text/csv; charset=windows-1251; header=present', disposition: "attachment; filename=report.csv"
  end

  action_item only: :index do
    link_to 'Export Report', params.merge(action: :property_report) if current_user.admin?
  end

  index download_links: false do
    selectable_column
    column :id
    column "State" do |property|
      property.state.titleize
    end
    column "Assigned Agent" do |property|
      link_to property.assigned_agent, admin_user_path(property.agent_id) if property.assigned_agent.present?
    end
    column "Cover Image" do |property|
      image_tag(property_cover_image(property), class: 'property-image')
    end
    column :category
    column "Society" do |property|
      property.location
    end
    column :title
    column :property_type
    column "Price (PKR.)", :price do |property|
      render_price(property.price)
    end
    column "Owner" do |property|
      link_to property.user.name.titleize, admin_user_path(property.user)
    end
    column :featured
    column :home_listing
    column "Property Deal closed at" do |property|
      span class: "#{closed_at_class(property)}" do
        property.closed_at_time
      end
    end

    actions name: "Actions"
  end

  show do
    attributes_table do
      row :id
      row "State" do |property|
        property.state.titleize
      end
      row "Assigned Agent" do |property|
        link_to property.assigned_agent, admin_user_path(property.agent_id) if property.assigned_agent.present?
      end
      row :category
      row "Address" do |property|
        property.full_address
      end
      row :title
      row :description
      row :property_type
      row :property_sub_type
      row "Property Features" do |property|
        property.property_features.join(', ')
      end
      row "Price (PKR.)", :price do |property|
        number_to_words(property.price)
      end
      row :land_area
      row :area_unit
      row :bedroom_count
      row :bathroom_count
      row "Owner" do |property|
        link_to property.user.name.titleize, admin_user_path(property.user)
      end
      row :featured
      row :home_listing
      row "Property Deal closed at" do |property|
        span class: "#{closed_at_class(property)}" do
          property.closed_at_time
        end
      end
      row "Property Deal Final Price (PKR.)", :end_price do |property|
        render_price(property.end_price)
      end
      row "Attachments" do
        if property.attachments.present?
          div do
            property.attachments.each do |attachment|
              span do
                image_tag attachment.image.url(:thumb)
              end
            end
          end
        end
      end

    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.has_many :attachments, allow_destroy: true do |attachment|
        attachment.input :image, hint: property_preview_image(attachment), input_html: { class: "imageInput" }
      end
      f.input :state, as: :select, collection: Property::STATES.map{ |state| [state.titleize, state] }, include_blank: 'Select One'
      f.input :agent, as: :select, collection: User.ordered_agents, include_blank: 'Select One'
      f.input :category, as: :select, collection: Property::CATEGORY, include_blank: 'Select One', input_html: { id: "admin-property-category" }
      f.input :property_type, as: :select, collection: Property::PROPERTY_TYPES, include_blank: 'Select One', input_html: { id: "admin-property-type" }
      f.input :property_sub_type, as: :select, collection: Property::PROPERTY_SUB_TYPES, include_blank: 'Select One', input_html: { id: "admin-property-sub-type" }
      f.input :property_features, as: :select, collection: Property::PROPERTY_FEATURES, include_blank: 'Select One or More', multiple: true, input_html: { class: "property-feature-select" }
      f.input :project_id, label: "Society", as: :select, collection: projects_options, include_blank: 'Select One', input_html: { class: 'admin-property-project' }
      f.input :sub_project_id, label: 'Sub Project', as: :select, collection: sub_projects_list, include_blank: 'Select One', input_html: { class: 'admin-property-sub-project' }
      f.input :city, as: :select, collection: Property::CITIES, include_blank: 'Select One'
      f.input :title, input_html: { maxlength: 50, placeholder: 'Enter Title' }
      f.input :description, input_html: { maxlength: 2000, placeholder: 'Enter Description' }
      f.input :price, label: "Price (PKR.)", input_html: { min: Property::MINIMUM_RANGE, max: Property::MAXIMUM_PRICE_RANGE }
      f.input :land_area, input_html: {  min: Property::MINIMUM_RANGE, max: Property::MAXIMUM_RANGE, required: true, placeholder: 'Enter Numeric' }
      f.input :area_unit, as: :select, collection: Property::UNITS, include_blank: 'Select One'
      f.input :bedroom_count, label: "Bedroom(s)", input_html: {  min: Property::MINIMUM_RANGE, max: Property::MAXIMUM_RANGE }
      f.input :bathroom_count, label: "Bathroom(s)", input_html: {  min: Property::MINIMUM_RANGE, max: Property::MAXIMUM_RANGE }
      f.input :user, label: "Owner"
      f.input :featured
      f.input :home_listing
      f.input :closed_at, label: 'Property Deal closed at', as: :datepicker, datepicker_options: { date_format: 'yy-mm-dd' }, input_html: { value: f.object.closed_at.try(:strftime, '%d-%m-%Y') }
      f.input :end_price, label: "Property Deal Final Price", input_html: {  min: Property::MINIMUM_RANGE, max: Property::MAXIMUM_PRICE_RANGE }
      f.actions
    end
  end

  permit_params do

    params = [:category, :city, :title, :description, :price, :land_area,
              :area_unit, :bedroom_count, :bathroom_count, :user_id, :featured,
              :property_type, :property_sub_type, :state, :agent_id, :project_id,
              :closed_at, :end_price, :home_listing, :sub_project_id,
              property_features: [], attachments_attributes: [:id, :image, :_destroy]]

    params
  end
end
