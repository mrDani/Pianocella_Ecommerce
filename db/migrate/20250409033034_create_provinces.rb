class CreateProvinces < ActiveRecord::Migration[7.2]
  def change
    create_table :provinces do |t|
      t.string :name
      t.decimal :pst
      t.decimal :gst

      t.timestamps
    end
  end
end
