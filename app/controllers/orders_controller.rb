class OrdersController < ApplicationController
  before_action :set_cart, only: [:new, :create]
  skip_before_action :authenticate_user!, only: [:new, :create, :success]

  def index
    @orders = user_signed_in? ? current_user.orders.includes(:order_items).order(created_at: :desc) : Order.where(user_id: nil).order(created_at: :desc)
  end

  def new
    if @cart.empty?
      redirect_to cart_path, alert: "Your cart is empty. Add products to proceed."
      return
    end

    @cart_items = fetch_cart_items
    @total_price = @cart_items.sum { |item| item[:subtotal] }

    @order = if user_signed_in?
      Order.new(
        name: current_user.username,
        email: current_user.email,
        shipping_address: current_user.address,
        city: current_user.city,
        province: current_user.province&.name || current_user.province,
        postal_code: current_user.postal_code
      )
    else
      Order.new
    end
    @provinces_json = Province.all.index_by(&:name).transform_values do |p|
      {
        pst: p.pst.to_f,
        gst: p.gst.to_f,
        hst: p.hst.to_f
      }
    end.to_json
  end

  def create
    if @cart.empty?
      redirect_to cart_path, alert: "Your cart is empty"
      return
    end
  
    order_params = params.require(:order).permit(:name, :email, :shipping_address, :city, :province, :postal_code)
    base_total = fetch_cart_items.sum { |item| item[:subtotal] }
  
    # 🔍 Look up the Province from the database
    province_record = Province.find_by(name: order_params[:province])
  
    # ✅ Fallback to 0.0 if not found
    pst_rate = province_record&.pst.to_f
    gst_rate = province_record&.gst.to_f
    hst_rate = province_record&.hst.to_f
  
    # 🧮 Tax calculations
    pst = base_total * pst_rate
    gst = base_total * gst_rate
    hst = base_total * hst_rate
    total_with_taxes = base_total + pst + gst + hst
  
    # 📝 Build the Order
    @order = Order.new(order_params)
    @order.status = "pending"
    @order.pst = pst
    @order.gst = gst
    @order.hst = hst
    @order.total_price = total_with_taxes
    @order.total_with_taxes = total_with_taxes
    @order.user = current_user if user_signed_in?
  
    # 👤 Update user profile info if logged in
    if user_signed_in?
      current_user.update(
        address: @order.shipping_address,
        city: @order.city,
        postal_code: @order.postal_code,
        province: province_record
      )
    end
  
    if @order.save
      save_cart_items_to_order(@order)
      session[:cart] = {}
      redirect_to order_path(@order), notice: "Order placed successfully. Please complete payment below."
    else
      @cart_items = fetch_cart_items
      render :new, status: :unprocessable_entity
    end
  end
  

  def show
    @order = Order.find_by(id: params[:id])
    redirect_to orders_path if @order.nil?
  end

  def success
    @order = Order.find_by(id: params[:order_id])
    redirect_to root_path if @order.nil?
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
