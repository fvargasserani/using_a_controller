class CartsController < ApplicationController
before_action :authenticate_user!

    def update
        product = params[:cart][:product_id]
        quantity = params[:cart][:quantity]
        current_order.add_product(product, quantity)
        redirect_to root_url, notice: "Product added successfuly"
    end

    def show
        @order = current_order
    end

    def pay_with_paypal
        @order = Order.find(params[:cart][:order_id])
        #price must be in cents
        price = order.total * 100
        
        response = EXPRESS_GATEWAY.setup_purchase(price,
        ip: request.remote_ip,
        return_url: process_paypal_payment_cart_url,
        cancel_return_url: root_url,
        allow_guest_checkout: true,
        currency: "USD"
        )
        
        process_paypal_payment
    end

    def choose_payment_method
        payment_method = PaymentMethod.find_by(code: "PEC")
        
        Payment.create(
        order_id: order.id,
        payment_method_id: payment_method.id,
        state: "processing",
        total: order.total,
        token: response.token
        )
        redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
    end

    private

    def set_cart
        @cart = Cart.find(params[:id])
    end

    def cart_params
        params.require(:cart).permit(:quantity, :product_id)
    end

end
