class AddHstToProvinces < ActiveRecord::Migration[7.2]
  def change
    add_column :provinces, :hst, :decimal
  end
end
