class AddAddressAndProvinceToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :address, :string
    add_column :users, :province, :string
  end
end
