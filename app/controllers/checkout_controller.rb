class CheckoutController < ApplicationController
    skip_before_action :authenticate_user!

    def create
      order = Order.find(params[:order_id])
  
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'cad',
            product_data: { name: "Order ##{order.id}" },
            unit_amount: (order.total_price * 100).to_i
          },
          quantity: 1
        }],
        mode: 'payment',
        success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}&order_id=#{order.id}",
        cancel_url: checkout_cancel_url
      )
  
      redirect_to session.url, allow_other_host: true
    end
  
    # def success
    #   session = Stripe::Checkout::Session.retrieve(params[:session_id])
    #   order = Order.find(params[:order_id])
  
    #   if order && session.payment_status == "paid"
    #     order.update(status: "paid", stripe_payment_id: session.payment_intent)
    #     redirect_to order_path(order), notice: "Payment successful!"
    #   else
    #     redirect_to root_path, alert: "Payment failed or not confirmed."
    #   end
    # end
    
    def success
        session = Stripe::Checkout::Session.retrieve(params[:session_id])
        @order = Order.find_by(id: params[:order_id])
      
        if @order && session.payment_status == "paid"
          @order.mark_as_paid(session.payment_intent)
          redirect_to order_path(@order), notice: "Payment successful and order marked as paid!"
        else
          redirect_to root_path, alert: "Payment failed or order not found."
        end
    end
      
  
    def cancel
      redirect_to orders_path, alert: "Payment was cancelled."
    end
  end
  