ActiveAdmin.register User do

  controller do
    before_action :validate_user, only: [:show, :edit, :update, :destroy]
    before_action :validate_admin, only: [:destroy]

    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end

    def scoped_collection
      super.includes :attachment
    end

    private

    def validate_user
      return redirect_to root_path, flash: { error: "You need to sign in" } unless user_signed_in?
      @user = User.find_by_id params[:id]
      return redirect_to admin_users_path, flash: { error: "User was not found" } if @user.blank?
    end

    def validate_admin
      return redirect_to admin_users_path, flash: { error: "You are not allowed to delete Admin" } if @user.admin?
    end

  end

  collection_action :subscriber_report, method: :get do
    users = User.subscribers
    csv = users.to_csv
    send_data csv.encode('Windows-1251'), type: 'text/csv; charset=windows-1251; header=present', disposition: "attachment; filename=report.csv"
  end

  collection_action :agent_report, method: :get do
    user = User.find_by_id(params[:id])
    properties = Property.assigned_properties(user)
    closed_properties = Property.deals_closed(user)
    csv = User.export_csv(properties, closed_properties, user)
    send_data csv.encode('Windows-1251'), type: 'text/csv; charset=windows-1251; header=present', disposition: "attachment; filename=report.csv"
  end

  action_item only: :index do
    link_to 'Export CSV', params.merge(action: :subscriber_report)
  end

  action_item only: :show do
    link_to 'Export Agent Report', params.merge(action: :agent_report) if user.agent? && current_user.admin?
  end

  scope :all
  scope "Users", :ordered_non_agents
  scope "Agents", :ordered_agents
  scope "Lawyers", :ordered_lawyers
  scope 'Architects', :ordered_architects
  scope "Subscribers", :ordered_subscribers

  index download_links: false do
    selectable_column
    column "Name" do |user|
      user.name.titleize
    end
    column "Email Address", :email
    column "City", :city
    column "Country", :country
    column "Mobile Number" do |user|
      user.mobile_number
    end
    column "Role", :role
    column "Subscriber", :subscriber

    actions name: "Actions"
  end

  show do
    attributes_table do
      row :attachment do
        user_profile_image(user.attachment)
      end
      row "Name" do |user|
        user.name.titleize
      end
      row :email
      row :address
      row :city
      row :country
      row 'Mobile Number' do
        user.mobile_number
      end
      row 'Home Number' do
        user.home_number
      end
      row 'Fax' do
        user.fax
      end
      row :zip_code
      row "Description" do
        user.agent_description
      end
      row :role
      row :subscriber
      if user.agent?
        row "Total Deals Closed" do
          Property.deals_closed(user).length
        end
        row "Assigned Properties" do
          assigned_properties_listing(user)
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.inputs "Attachment", for: [:attachment, f.object.attachment || Attachment.new] do |attachment|
        attachment.input :image, as: :file, hint: user_preview_image(attachment), input_html: { class: "imageInput" }
        attachment.input :_destroy, as: :boolean, required: false, label: 'Remove image' if attachment.object.image.present?
      end
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :address
      f.input :city, as: :select, collection: User::CITIES, include_blank: 'Select One'
      f.input :country, as: :select, collection: User::COUNTRIES, include_blank: 'Select One'
      f.input :mobile_phone_code, input_html: { maxlength: 4, required: true, pattern: '(03\d{2})', placeholder: "0300" }
      f.input :mobile_phone_number, input_html: { maxlength: 7, required: true, pattern: '(\d{7})', placeholder: "1111111" }
      f.input :home_phone_code, input_html: { maxlength: 4, required: true, pattern: '(0\d{2,3})', placeholder: "042" }
      f.input :home_phone_number, input_html: { maxlength: 8, required: true, pattern: '(\d{8})', placeholder: "11111111" }
      f.input :fax_code, input_html: { maxlength: 4, pattern: '(0\d{2,3})', placeholder: "042" }
      f.input :fax_number, input_html: { maxlength: 7, pattern: '(\d{7})', placeholder: "1111111" }
      f.input :zip_code, input_html: { maxlength: 9, pattern: '(\d{4,9})' }
      f.input :agent_description, label: "Description", input_html: { maxlength: 255 }
      f.input :subscriber
      f.input :role, as: :select, collection: user_roles, include_blank: 'Select One' if current_user.admin?
      f.actions
    end
  end

  permit_params   :email, :role, :name, :home_phone_code, :home_phone_number, :mobile_phone_code,
                  :mobile_phone_number, :subscriber, :agent_description, :fax_code,
                  :fax_number, :city, :country, :address, :zip_code, :password, :password_confirmation, attachment_attributes: [:id, :image, :_destroy]

end
