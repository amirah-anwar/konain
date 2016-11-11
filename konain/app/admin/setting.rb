ActiveAdmin.register Setting do

  actions :all, except: [:destroy]

  index download_links: false do
    selectable_column
    column "Setting Title" do |setting|
      setting.title
    end
    column :apply

    actions name: "Actions"
  end

  show do
    attributes_table do
      row "Setting Title" do |setting|
        setting.title
      end
      row :apply
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :title, input_html: { required: true, maxlength: 20 }, label: "Setting Name"
      f.input :apply
      f.actions
    end
  end

  permit_params :title, :apply
end
