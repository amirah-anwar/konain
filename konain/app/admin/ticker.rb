ActiveAdmin.register Ticker do
  menu label: "News Ticker"

  index download_links: false do
    selectable_column
    column :title
    column :content

    actions name: "Actions"
  end

  show do
    attributes_table do
      row :title
      row :content
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :title, input_html: { required: true, maxlength: 20, placeholder: "Enter ticker title" }, label: "Ticker Title"
      f.input :content, input_html: { required: true, maxlength: 255, placeholder: "Enter ticker content" }, label: "Ticker Content"
      f.actions
    end
  end

  permit_params :title, :content

end
