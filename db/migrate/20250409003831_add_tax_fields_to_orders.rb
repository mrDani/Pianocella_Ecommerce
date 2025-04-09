class AddTaxFieldsToOrders < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:orders, :pst)
      add_column :orders, :pst, :decimal, precision: 10, scale: 2, default: 0.0
    end

    unless column_exists?(:orders, :gst)
      add_column :orders, :gst, :decimal, precision: 10, scale: 2, default: 0.0
    end

    unless column_exists?(:orders, :total_with_taxes)
      add_column :orders, :total_with_taxes, :decimal, precision: 10, scale: 2, default: 0.0
    end
  end
end
