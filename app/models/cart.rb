class Cart < ApplicationRecord
has_many :orders
has_many :payments
belongs_to :user

def add_product(product, quantity)
    @order = params[:product_id][:quantity]
    @cart = {}
     Order.all.each do |order| 
        if current_order.include?(@order)
          @cart << order
        end
    end
end

def purchase_setup
    price = order.total * 100 #price must be in cents
    response = EXPRESS_GATEWAY.setup_purchase(price,
        ip: request.remote_ip,
        return_url: process_paypal_payment_cart_url,
        cancel_return_url: root_url,
        allow_guest_checkout: true,
        currency: "USD"
    )
end

def process_payment
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

def purchase
    details = EXPRESS_GATEWAY.details_for(params[:token])
    express_purchase_options = {
        ip: request.remote_ip,
        token: params[:token],
        payer_id: details.payer_id,
        currency: "USD"
    }
    price = details.params["order_total"].to_d * 100
    response = EXPRESS_GATEWAY.purchase(price, express_purchase_options)  
end

def status
    if response.success?
        payment = Payment.find_by(token: response.token)
        order = payment.order
        #update object states
        payment.state = "completed"
        order.state = "completed"
        ActiveRecord::Base.transaction do
            order.save!
            payment.save!
        end  
    end
end