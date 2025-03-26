ActiveAdmin.register Page do
    permit_params :title, :slug, :content
  
    form do |f|
      f.inputs do
        f.input :title
        f.input :slug
        f.input :content, as: :text, input_html: { id: "ckeditor-content" }
      end
      f.actions
    end
  
    show do
      attributes_table do
        row :title
        row :slug
        row :content do |page|
          page.content&.html_safe
        end
      end
    end
  end
  