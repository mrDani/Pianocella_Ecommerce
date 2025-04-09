class OrdersController < ApplicationController
  before_action :set_cart, only: [:new, :create]
  skip_before_action :authenticate_user!, only: [:new, :create, :success]

  def index
    if user_signed_in?
      @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
    else
      @orders = Order.where(user_id: nil).order(created_at: :desc)
    end
  end

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
  
    order_params = params.require(:order).permit(:name, :email, :shipping_address, :city, :province, :postal_code)
  
    # Calculate base subtotal
    base_total = fetch_cart_items.sum { |item| item[:subtotal] }
  
    # Determine tax rates based on province
    pst_rate = case order_params[:province]
               when "Manitoba" then 0.07
               when "Alberta" then 0.00
               when "British Columbia" then 0.07
               when "Ontario" then 0.08
               when "Quebec" then 0.09975
               when "Saskatchewan" then 0.06
               when "New Brunswick", "Newfoundland and Labrador", "Nova Scotia", "Prince Edward Island" then 0.10
               else 0.00
               end
  
    gst_rate = 0.05
  
    # Tax calculations
    pst = base_total * pst_rate
    gst = base_total * gst_rate
    total_with_taxes = base_total + pst + gst
  
    # Build order with tax data
    @order = Order.new(order_params)
    @order.status = "pending"
    @order.pst = pst
    @order.gst = gst
    @order.total_price = total_with_taxes # <-- Save final total here
    @order.total_with_taxes = total_with_taxes
    @order.user = current_user if user_signed_in?
  
    if @order.save
      save_cart_items_to_order(@order)
      session[:cart] = {}
  
      if user_signed_in?
        redirect_to orders_path, notice: "Order placed successfully!"
      else
        redirect_to order_success_path(order_id: @order.id), notice: "Order placed successfully!"
      end
    else
      @cart_items = fetch_cart_items
      render :new, status: :unprocessable_entity
    end
  end
  



  

  def show
    @order = Order.find_by(id: params[:id])

    if @order.nil?
      # redirect_to orders_path, alert: "Order not found."
      redirect_to orders_path
    end
  end

  def success
    @order = Order.find_by(id: params[:order_id])

    if @order.nil?
      # redirect_to root_path, alert: "Order not found."
      redirect_to root_path
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
    params.require(:order).permit(:name, :email, :shipping_address, :city, :province, :postal_code)
  end
end
