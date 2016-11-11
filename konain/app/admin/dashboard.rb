ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }, id: "section0"

    sidebar :quick_links, class: 'dashboard_side_bar' do
      ul do
        li link_to "Go to Top", "#section0"
        li link_to "Recent Properties", "#section1"
        li link_to "Recent Agents", "#section2"
        li link_to "Recent Users", "#section3"
      end
    end

  content title: proc { I18n.t("active_admin.dashboard") } do
    div data_spy: "scroll", data_target: "#sidebar", data_offset: "50" do
      section do
        h2 do
          "Statistics"
        end
        h4 do
          "Properties Uploaded in a"
        end
        columns do
          column max_width: "100px", min_width: "50px" do
             h6 do
              "Day"
            end
            span do
              Property.properties_added_in_day.length
            end
          end
          column max_width: "100px", min_width: "50px" do
            h6 do
              "Week"
            end
            span do
              Property.properties_added_in_week.length
            end
          end
          column max_width: "100px", min_width: "50px" do
            h6 do
              "Month"
            end
            span do
              Property.properties_added_in_month.length
            end
          end
        end
      end

      div id: "section1" do
        section strong "Recent Properties" do
          table_for Property.includes(:attachments).ordered.limit(20) do
            column "Cover Image" do |property|
              image_tag property_cover_image(property), class: 'dash-property-image'
            end
            column "State" do |property|
              property.state.titleize
            end
            column "Assigned Agent" do |property|
              link_to property.assigned_agent, admin_user_path(property.agent_id) if property.assigned_agent.present?
            end
            column "Owner" do |property|
              link_to property.user.name.titleize, admin_user_path(property.user)
            end
            column :category
            column :title do |property|
              div class: "title_col" do
                link_to property.title, [:admin, property]
              end
            end
            column "Address" do |property|
              div class: "address_col" do
                property.full_address
              end
            end
            column "Property Type" do |property|
              display_property_type(property)
            end
            column "Price (PKR.)", :price do |property|
              render_price(property.price)
            end
            column :land_area
            column :area_unit
            column "Added on", :created_at
            column 'Actions' do |property|
              link_to "View", admin_property_path(property) if authorized? :read, property
            end
            column do |property|
              link_to "Edit", edit_admin_property_path(property) if authorized? :update, property
            end
            column do |property|
              link_to "Delete", property, method: :delete, data: { confirm: "Are you sure?" } if authorized? :destroy, property
            end
          end
          strong { link_to "View All Properties", admin_properties_path }
        end
      end

      hr do
      end

      div id: "section2" do
        section strong "Recent Agents" do
          table_for User.includes(:attachment).ordered_agents.limit(20) do
            column "Profile Image" do |user|
              user_profile_image(user.attachment)
            end
            column :email
            column :name do |user|
              div class: "name_col" do
                link_to user.name, [:admin, user]
              end
            end
            column "City", :city
            column "Mobile Number" do |user|
              user.mobile_number
            end
            column "Mobile Number" do |user|
              user.mobile_number
            end
            column "Recent Assigned Properties" do |user|
              recent_assigned_properties_listing(user)
            end
            column 'Actions' do |user|
              link_to "View", admin_user_path(user) if authorized? :read, user
            end
            column do |user|
              link_to "Edit", edit_admin_user_path(user) if authorized? :update, user
            end
            column do |user|
              link_to "Delete", user, method: :delete, data: { confirm: "Are you sure?" } if authorized? :destroy, user
            end
          end
        end
      end

      hr do
      end

      div id: "section3" do
        section strong "Recent Users" do
          table_for User.includes(:attachment).ordered_non_agents.limit(20) do
            column "Profile Image" do |user|
              user_profile_image(user.attachment)
            end
            column :email
            column :name do |user|
              div class: "name_col" do
                link_to user.name, [:admin, user]
              end
            end
            column "Address" do
              div class: "user_address_col" do
                :address
              end
            end
            column "City", :city
            column "Country", :country
            column "Mobile Number" do |user|
              user.mobile_number
            end
            column "Home Number" do |user|
             user.home_number
            end
            column "Subscriber", :subscriber
            column 'Actions' do |user|
              link_to "View", admin_user_path(user) if authorized? :read, user
            end
            column do |user|
              link_to "Edit", edit_admin_user_path(user) if authorized? :update, user
            end
            column do |user|
              link_to "Delete", user, method: :delete, data: { confirm: "Are you sure?" } if authorized? :destroy, user
            end
          end
          strong { link_to "View All Users", admin_users_path }
        end
      end

    end
  end

end
