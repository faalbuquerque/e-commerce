require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include('must be greater than or equal to 0')
    end
  end

  describe 'marks as abandoned' do
    let(:cart) { create(:cart, updated_at: 3.hours.ago) }

    it 'marks the shopping cart as abandoned if inactive for for 3 hours' do
      expect { ExpireCartsJob.new.perform(cart.id) }.to change { cart.reload.abandoned? }.from(false).to(true)
    end
  end

  describe 'remove if abandoned' do
    before { create(:cart, status: 'abandoned', updated_at: 7.days.ago) }

    it 'removes the shopping cart if abandoned for 7 days' do
      expect { RemoveExpiredCartsJob.new.perform }.to change { Cart.count }.by(-1)
    end
  end
end
