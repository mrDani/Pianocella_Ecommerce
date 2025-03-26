module CurrentCart
    extend ActiveSupport::Concern
  
    private
  
    def current_cart
      session[:cart] ||= {}
    end
  end
  