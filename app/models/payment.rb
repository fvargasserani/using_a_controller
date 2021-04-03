class Payment < ApplicationRecord
    belongs_to :cart
    belongs_to :payment_method
end
