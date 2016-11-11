ActiveAdmin.register Page do

  controller do

    def destroy
      record = Page.find params[:id]
      if record.permalink.in?(Page::DEFAULT_LINKS)
        flash[:error] = "You cannot destroy default pages"
        redirect_to :back
      else
        super
      end
    end

  end

  index download_links: false do
    selectable_column
    column "Title" do |page|
      page.name
    end
    column :permalink
    column "Banner" do |page|
      custom_page_banner_image(page.banner.try(:image))
    end
    column "Content" do |page|
      div class: "email_message" do
        raw page.content.truncate(500) if page.content.present?
      end
    end

    actions name: "Actions"
  end

  show do
    attributes_table do
      row "Title" do |page|
        page.name
      end
      row :permalink
      row "Banner" do |page|
       custom_page_banner_image(page.banner.try(:image))
      end
      row "Content" do |page|
        div class: "email_message" do
          page.content.html_safe if page.content.present?
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name, label: "Title"
      li do
        f.label "Content", class: "label"
      end
      f.inputs "Banner", for: [:banner, f.object.banner || Banner.new] do |banner|
        banner.input :image, as: :file, hint: custom_page_banner_image_preview(banner), input_html: { class: "imageInput" }
        banner.input :_destroy, as: :boolean, required: false, label: 'Remove image'
      end
      f.input :content, as: :ckeditor, input_html: { ckeditor: { height: 400, toolbar: 'Full' } }, label: false
      f.actions
    end
  end

  permit_params :content, :name, banner_attributes: [:id, :image, :_destroy]

end
