class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: [:new, :create]

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
  
    @order = current_user.orders.build(order_params)
    @order.status = "pending"
    @order.total_price = fetch_cart_items.sum { |item| item[:subtotal] }
  
    puts "Order Parameters Received: #{order_params.inspect}"
    puts "Order Built: #{@order.inspect}"
    
    if @order.save
      puts "✅ Order saved successfully!"
      save_cart_items_to_order(@order)
      current_user.update(
        address: @order.shipping_address,
        city: @order.city,
        province: @order.province,
        postal_code: @order.postal_code
      )
      session[:cart] = {} # Clear the cart
      redirect_to order_path(@order), notice: "Order placed successfully!"
    else
      puts "❌ Order failed to save!"
      puts "🛑 Errors: #{@order.errors.full_messages.join(', ')}"
      @cart_items = fetch_cart_items
      render :new, status: :unprocessable_entity
    end
  end
  

  def index
    @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
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
    params.require(:order).permit(:shipping_address, :city, :province, :postal_code)
  end
end
