Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :cart, only: [:show, :update] do
    member do
      post :pay_with_paypal
      get :process_paypal_payment
    end
  end
end
