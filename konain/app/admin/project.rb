ActiveAdmin.register Project do

  controller do
    def scoped_collection
      super.includes :attachments, :sub_projects
    end
  end

  index download_links: false do
    selectable_column
    column "Cover Image" do |project|
      image_tag(property_cover_image(project), class: 'property-image')
    end
    column "Title" do |project|
      div class: "project_title" do
        project.title.titleize
      end
    end
    column 'Sub Projects' do |project|
      sub_projects_titleize(project)
    end
    column :city
    column "Location" do |project|
      div class: "project_location" do
        project.location.titleize
      end
    end

    actions name: "Actions"
  end

  show do
    attributes_table do
      row "Title" do |project|
        project.title.titleize
      end
      row :city
      row :country
      row "Location" do |project|
        project.location.titleize
      end
      row "Description" do |project|
          project.description
      end
      row 'Sub Projects' do |project|
        sub_projects_titleize(project)
      end
      row "Included Properties" do |project|
        project_properties_listing(project)
      end
      row "Attachments" do
        if project.attachments.present?
          div do
            project.attachments.each do |attachment|
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
      f.input :title, input_html: { maxlength: 30, placeholder: 'Enter Title' }
      f.input :description, input_html: { maxlength: 2000, placeholder: 'Enter Description' }
      f.input :country, as: :select, collection: Project::COUNTRIES, include_blank: 'Select One'
      f.input :city, as: :select, collection: Project::CITIES, include_blank: 'Select One'
      f.input :location, input_html: { maxlength: 60, placeholder: 'Enter Location' }
      f.actions
    end
  end

  permit_params do
    params = [:title, :description, :location, :city, :country, :latitude, :longitude,
              attachments_attributes: [:id, :image, :_destroy]]

    params
  end

end
