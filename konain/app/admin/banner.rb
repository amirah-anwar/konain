ActiveAdmin.register Banner do

  config.filters = false
  actions :all, except: [:destroy]

  index download_links: false do
    column "Banner Image" do |banner|
      banner_image(banner)
    end
    column "Page Name" do |banner|
      banner.name
    end
    actions name: "Actions"
  end

  show do
    attributes_table do
      row "Banner Image" do |banner|
        banner_image(banner)
      end
      row "Page Name" do |banner|
        banner.name
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name, as: :select, collection: Banner::PAGES, required: true, include_blank: 'Select One'
      f.input :image, as: :file, hint: banner_image_preview(f.object), input_html: { class: "imageInput" }
      f.input :remove_image, as: :boolean, required: false, label: 'Remove image'
    end
    f.actions
  end

  permit_params :name, :image, :remove_image
end
