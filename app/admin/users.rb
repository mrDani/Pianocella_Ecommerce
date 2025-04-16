ActiveAdmin.register User do
    permit_params :username, :email, :province_id, :address, :city, :postal_code
  
    index do
      selectable_column
      id_column
      column :username
      column :email
      column("Province") { |user| user.province&.name }
      column :address
      column :city
      column :postal_code
      column :created_at
      actions
    end
  
    filter :username
    filter :email
    filter :province
    filter :created_at
  
    form do |f|
      f.inputs do
        f.input :username
        f.input :email
        f.input :province, as: :select, collection: Province.all.map { |p| [p.name, p.id] }
        f.input :address
        f.input :city
        f.input :postal_code
      end
      f.actions
    end
  end
  