class OrdersController < ApplicationController
  before_action :set_cart, only: [:new, :create]
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    if @cart.empty?
      redirect_to cart_path, alert: "Your cart is empty. Add products to proceed."
      return
    end

    @cart_items = fetch_cart_items
    @total_price = @cart_items.sum { |item| item[:subtotal] }
    @order = Order.new
  end

  def create
    if @cart.empty?
      redirect_to cart_path, alert: "Your cart is empty"
      return
    end

    @order = Order.new(order_params)
    @order.status = "pending"
    @order.total_price = fetch_cart_items.sum { |item| item[:subtotal] }

    if @order.save
      save_cart_items_to_order(@order)
      session[:cart] = {} # Clear the cart
      redirect_to order_path(@order), notice: "Order placed successfully!"
    else
      @cart_items = fetch_cart_items
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_cart
    session[:cart] ||= {}
    @cart = session[:cart]
  end

  def fetch_cart_items
    products = Product.where(id: @cart.keys)
    products.map do |product|
      quantity = @cart[product.id.to_s].to_i
      {
        product: product,
        quantity: quantity,
        subtotal: product.price * quantity
      }
    end
  end

  def save_cart_items_to_order(order)
    @cart.each do |product_id, quantity|
      product = Product.find(product_id)
      order.order_items.create(
        product: product,
        quantity: quantity,
        unit_price: product.price
      )
    end
  end

  def order_params
    params.require(:order).permit(:name, :shipping_address, :city, :province, :postal_code, :email)
  end
end
