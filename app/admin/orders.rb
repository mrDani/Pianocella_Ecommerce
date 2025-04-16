ActiveAdmin.register Order do
  permit_params :user_id, :name, :email, :shipping_address, :city, :province, :postal_code, :status, :total_price, :pst, :gst, :hst

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

    column :pst do |order|
      number_to_currency(order.pst || 0)
    end

    column :gst do |order|
      number_to_currency(order.gst || 0)
    end

    column :hst do |order|
      number_to_currency(order.hst || 0)
    end

    column :total_price do |order|
      number_to_currency(order.total_price || 0)
    end

    column :status

    column "Items Ordered" do |order|
      order.order_items.map { |item| "#{item.product.name} × #{item.quantity}" }.join(", ").html_safe
    end

    column :created_at
    actions
  end

  filter :user_id, as: :select, collection: -> { User.pluck(:username, :id) }
  filter :name
  filter :email
  filter :province
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
      f.input :pst
      f.input :gst
      f.input :hst
      f.input :total_price
      f.input :status, as: :select, collection: ['pending', 'paid', 'shipped', 'completed', 'cancelled']
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
      row("PST") { number_to_currency(order.pst || 0) }
      row("GST") { number_to_currency(order.gst || 0) }
      row("HST") { number_to_currency(order.hst || 0) }
      row("Total Price") { number_to_currency(order.total_price || 0) }
      row :status
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :unit_price
        column("Total") { |item| number_to_currency(item.quantity * item.unit_price) }
      end
    end
  end
end
