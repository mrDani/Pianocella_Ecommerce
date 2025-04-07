ActiveAdmin.register Order do
    permit_params :user_id, :name, :email, :shipping_address, :city, :province, :postal_code, :status, :total_price
  
    index do
      selectable_column
      id_column
      column :user do |order|
        order.user ? order.user.username : "Guest"
      end
      column :name
      column :email
      column :shipping_address
      column :city
      column :province
      column :postal_code
      column :status
      column :total_price
      column :created_at
      actions
    end
  
    filter :user_id, as: :select, collection: -> { User.pluck(:username, :id) }
    filter :name
    filter :email
    filter :status
    filter :created_at
  
    form do |f|
      f.inputs do
        f.input :user, as: :select, collection: User.all.map { |u| [u.username, u.id] }, include_blank: "Guest"
        f.input :name
        f.input :email
        f.input :shipping_address
        f.input :city
        f.input :province
        f.input :postal_code
        f.input :status, as: :select, collection: ['pending', 'paid', 'shipped', 'completed', 'cancelled']
        f.input :total_price
      end
      f.actions
    end
  
    show do
      attributes_table do
        row :user do |order|
          order.user ? order.user.username : "Guest"
        end
        row :name
        row :email
        row :shipping_address
        row :city
        row :province
        row :postal_code
        row :status
        row :total_price
        row :created_at
        row :updated_at
      end
  
      panel "Order Items" do
        table_for order.order_items do
          column :product
          column :quantity
          column :unit_price
          column :total do |item|
            item.quantity * item.unit_price
          end
        end
      end
    end
  end
  