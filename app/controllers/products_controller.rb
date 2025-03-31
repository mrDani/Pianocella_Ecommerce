class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Product.all
  
    if params[:query].present?
      @products = @products.where("name ILIKE ?", "%#{params[:query]}%")
    end
  
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    # Order from newest to oldest
    @products = @products.order(created_at: :desc)
  
    # Paginate products
    @products = @products.page(params[:page]).per(12)
  end
  
  def show
    # The @product is already set by the set_product method below.
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to products_path, alert: "Product not found or has been deleted."
    end
  end
end

