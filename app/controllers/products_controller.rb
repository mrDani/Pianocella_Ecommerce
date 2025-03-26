class ProductsController < ApplicationController
  def index
    @products = Product.all
  
    if params[:query].present?
      @products = @products.where("name ILIKE ?", "%#{params[:query]}%")
    end
  
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end
  
    @products = @products.page(params[:page]).per(12)
  end
  

  def show
    @product = Product.find(params[:id])
  end
end
