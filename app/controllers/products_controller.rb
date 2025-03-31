class ProductsController < ApplicationController
  # before_action :set_product, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @products = Product.all

    if params[:query].present?
      @products = @products.where("name ILIKE ?", "%#{params[:query]}%")
    end

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    # Filter for "Recently Updated" products (last 3 days)
    if params[:recently_updated].present?
      @products = @products.where("updated_at >= ?", 3.days.ago)
    end

    # Filter for "New This Week" products (last 3 days, ONLY NEWLY CREATED)
    if params[:new_this_week].present?
      @products = @products.where("created_at >= ?", 3.days.ago)
    end

    @products = @products.order(created_at: :desc).page(params[:page]).per(12)
  end
  
  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      redirect_to products_path, alert: "Product not found or has been deleted."
    end
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to products_path, alert: "Product not found or has been deleted."
    end
  end
end

