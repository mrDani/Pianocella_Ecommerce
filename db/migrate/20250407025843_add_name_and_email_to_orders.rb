class AddNameAndEmailToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :name, :string
    add_column :orders, :email, :string
  end
end
