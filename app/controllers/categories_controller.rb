class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @q = @category.products.ransack(params[:q])
    @products = @q.result.page(params[:page]).per(12)
  end
end
