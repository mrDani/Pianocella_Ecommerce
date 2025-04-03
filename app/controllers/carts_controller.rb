class CartsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :add_item, :update_quantity, :remove_item]
  before_action :set_cart

  def show
    @cart_items = []

    if @cart.present?
      products = Product.where(id: @cart.keys)
      @cart_items = products.map do |product|
        quantity = @cart[product.id.to_s].to_i
        {
          product: product,
          quantity: quantity,
          subtotal: product.price * quantity
        }
      end
    end
  end

  def add_item
    id = params[:product_id].to_s
    @cart[id] = (@cart[id] || 0) + params[:quantity].to_i
    save_cart
    redirect_to cart_path, notice: "Product added to cart." # Redirecting to cart_path instead of checkout
  end
  def update_quantity
    id = params[:product_id].to_s
    @cart ||= {}
    @cart[id] = params[:quantity].to_i
    save_cart
    redirect_to cart_path, notice: "Cart updated."
  end

  def remove_item
    @cart ||= {}
    @cart.delete(params[:product_id].to_s)
    save_cart
    redirect_to cart_path, notice: "Product removed."
  end

  private

  def set_cart
    session[:cart] ||= {}
    @cart = session[:cart]
  end

  def save_cart
    session[:cart] = @cart
  end
end
