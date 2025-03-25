class ProductsController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.page(params[:page]).per(10)
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
  end
end
