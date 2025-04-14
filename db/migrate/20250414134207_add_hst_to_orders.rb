class AddHstToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :hst, :decimal
  end
end
