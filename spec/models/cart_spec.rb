require 'rails_helper'
require 'spec_helper'

RSpec.describe Cart, type: :model do
  it "should not be empty" do

    cart = Cart.create(quantity: ' ')
    expect(cart).to_not be_valid

    cart = Cart.create(quantity: nil)
    expect(cart).to_not be_valid

    cart = Cart.create(quantity: 0)
    expect(cart).to_not be_valid
    
    cart = Cart.create(quantity: 1)
    expect(cart).to be_valid
  end
end

RSpec.describe Cart, type: :model do
  it { should validate_presence_of(:product_id) }
end

RSpec.describe Cart, type: :model do
  it { should validate_presence_of(:quantity) }
end
