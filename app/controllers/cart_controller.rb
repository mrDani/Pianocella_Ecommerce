class CartController < ApplicationController
  before_action :set_cart

  def show
    @cart_items = Product.find(@cart.keys).map do |product|
      {
        product: product,
        quantity: @cart[product.id.to_s],
        subtotal: product.price * @cart[product.id.to_s]
      }
    end
  end

  def add_item
    id = params[:product_id].to_s
    @cart[id] = (@cart[id] || 0) + 1
    save_cart
    redirect_to cart_path, notice: "Product added to cart."
  end

  def update_quantity
    id = params[:product_id].to_s
    @cart[id] = params[:quantity].to_i
    save_cart
    redirect_to cart_path, notice: "Cart updated."
  end

  def remove_item
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
