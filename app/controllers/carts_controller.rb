class CartsController < ApplicationController
    validates :product_id, presence: true
    validates :quantity, presence: true
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
        @order.purchase_setup
        @order.process_payment
    end

    def process_paypal_payment
        @order = Order.find(params[:cart][:order_id])
        @order.purchase
        @order.status 
        redirect_to root_url, notice: "Payment completed"
    end

    private

    def set_cart
        @cart = Cart.find(params[:id])
    end

    def cart_params
        params.require(:cart).permit(:quantity, :product_id)
    end

end
