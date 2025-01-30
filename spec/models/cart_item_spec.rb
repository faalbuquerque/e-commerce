require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:cart) { create(:cart) }

  describe '#total_price' do
    let(:product) { create(:product, name: 'M&Ms', price: 15.00) }
    let(:cart_item) { create(:cart_item, quantity: 2, product: product, cart: cart) }

    subject { cart_item.total_price.to_f }

    it { expect(subject).to eq(30.00) }
  end

  describe '#adjust_quantity' do
    context 'when receives values ​​equal to or above zero' do
      let(:cart_item) { create(:cart_item, quantity: 3, cart: cart) }

      before { cart_item.adjust_quantity(2) }

      it { expect(cart_item.reload.quantity).to eq(5) }
    end

    context 'when receives values ​​equal to or below zero' do
      let(:cart_item) { create(:cart_item, quantity: 3, cart: cart) }

      before { cart_item.adjust_quantity(-3) }

      it { expect(cart_item.reload.quantity).to be_zero }
    end
  end
end
