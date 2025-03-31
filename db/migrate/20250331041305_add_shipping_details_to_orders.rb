class AddShippingDetailsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :address, :string unless column_exists?(:orders, :address)
    add_column :orders, :city, :string unless column_exists?(:orders, :city)
    add_column :orders, :province, :string unless column_exists?(:orders, :province)
    add_column :orders, :postal_code, :string unless column_exists?(:orders, :postal_code)
  end
end
