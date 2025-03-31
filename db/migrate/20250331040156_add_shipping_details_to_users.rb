class AddShippingDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :city, :string unless column_exists?(:users, :city)
    add_column :users, :postal_code, :string unless column_exists?(:users, :postal_code)
  end
end
