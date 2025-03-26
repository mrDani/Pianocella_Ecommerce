class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = session[:cart] || {}
    @cart_items = Product.find(@cart.keys).map do |product|
      {
        product: product,
        quantity: @cart[product.id.to_s].to_i
      }
    end
  end

  def create
    cart = session[:cart] || {}
    if cart.empty?
      redirect_to cart_path, alert: "Your cart is empty"
      return
    end

    @order = current_user.orders.build(
      address: current_user.address,
      province: current_user.province,
      status: "pending",
      total_price: 0
    )

    cart.each do |product_id, quantity|
      product = Product.find(product_id)
      @order.order_items.build(
        product: product,
        quantity: quantity,
        unit_price: product.price
      )
    end

    @order.total_price = @order.order_items.sum { |item| item.quantity * item.unit_price }

    if @order.save
      session[:cart] = {} # clear cart
      redirect_to @order, notice: "Order placed successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @orders = current_user.orders.includes(:order_items)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end
