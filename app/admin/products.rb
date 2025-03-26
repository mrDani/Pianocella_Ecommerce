ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :price, :inventory_quantity, :category_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price, :inventory_quantity, :category_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :name, :description, :price, :inventory_quantity, :category_id, :image
  
  remove_filter :order_items

  filter :name
  filter :price
  filter :category
end
