ActiveAdmin.register SubProject do

  controller do
    def scoped_collection
      super.includes :attachments
    end
  end

  index download_links: false do
    selectable_column
    column 'Cover Image' do |sub_project|
      image_tag property_cover_image(sub_project), class: 'property-image'
    end
    column 'Title' do |sub_project|
      div class: 'project_title' do
        titleize(sub_project.title)
      end
    end
    column 'Project' do |sub_project|
      link_to_project(sub_project)
    end
    column :city
    column 'Location' do |sub_project|
      div class: 'project_location' do
        titleize(sub_project.location)
      end
    end

    actions name: 'Actions'
  end

  show do
    attributes_table do
      row 'Title' do |sub_project|
        titleize(sub_project.title)
      end
      row 'Project' do |sub_project|
        link_to_project(sub_project)
      end
      row :city
      row :country
      row 'Location' do |sub_project|
        titleize(sub_project.location)
      end
      row 'Description' do |sub_project|
          sub_project.description
      end
      row 'Included Properties' do |sub_project|
        project_properties_listing(sub_project)
      end
      row 'Attachments' do
        if sub_project.attachments.present?
          div do
            sub_project.attachments.each do |attachment|
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
        attachment.input :image, hint: property_preview_image(attachment), input_html: { class: 'imageInput' }
      end
      f.input :title, input_html: { maxlength: 30, placeholder: 'Enter Title' }
      f.input :description, input_html: { maxlength: 2000, placeholder: 'Enter Description' }
      f.input :project, as: :select, collection: Project.all, include_blank: 'Select One'
      f.input :country, as: :select, collection: Project::COUNTRIES, include_blank: 'Select One'
      f.input :city, as: :select, collection: Project::CITIES, include_blank: 'Select One'
      f.input :location, input_html: { maxlength: 60, placeholder: 'Enter Location' }
      f.actions
    end
  end

  permit_params do
    params = [:title, :description, :location, :project_id, :city, :country, :latitude, :longitude,
              attachments_attributes: [:id, :image, :_destroy]]

    params
  end

end
