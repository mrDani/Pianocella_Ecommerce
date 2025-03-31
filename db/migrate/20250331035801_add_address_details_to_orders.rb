class AddAddressDetailsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :shipping_address, :string, null: false
    add_column :orders, :city, :string, null: false
    add_column :orders, :province, :string, null: false
    add_column :orders, :postal_code, :string, null: false
  end
end
