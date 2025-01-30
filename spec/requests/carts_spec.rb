require 'rails_helper'

RSpec.describe '/carts', type: :request do
  let(:cart) { create(:cart, :empty) }

  before do
    session = { cart_id: cart.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
  end

  describe 'GET /cart' do
    let(:pen) { create(:product, name: 'Caneta', price: 10.0) }
    let(:pencil) { create(:product, name: 'Lapis', price: 5.0) }
    let(:cart_item_1) { create(:cart_item, cart: cart, product: pen, quantity: 1) }
    let(:cart_item_2) { create(:cart_item, cart: cart, product: pencil, quantity: 1) }

    it 'shows cart' do
      result = { 'id' => cart.id,
                 'products' => [
                    { 'id' => pen.id, 'name' => "#{cart_item_1.product.name}", 'quantity' => 1, 'unit_price' => '10.0', 'total_price' => '10.0' },
                    { 'id' => pencil.id, 'name' => "#{cart_item_2.product.name}", 'quantity' => 1, 'unit_price' => '5.0', 'total_price' => '5.0' },
                  ],
                 'total_price' => '15.0'
               }

      get '/cart', as: :json
      response = JSON.parse(@response.body)

      expect(response).to eq(result)
    end
  end

  describe 'POST /cart' do
    let(:caneta) { create(:product, name: 'Caneta', price: 10.0) }

    let(:valid_attributes) do
      {
        'product_id': caneta.id,
        'quantity': 1
      }
    end

    it 'creates cart' do
      result = { 'id' => cart.id,
                 'products' => [
                    { 'id' => caneta.id, 'name' => "Caneta", 'quantity' => 1, 'unit_price' => '10.0', 'total_price' => '10.0' },
                  ],
                 'total_price' => '10.0'
               }

      post '/cart', params: valid_attributes, as: :json
      response = JSON.parse(@response.body)

      expect(response).to eq(result)
    end
  end

  describe 'PUT /add_items' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, name: "Test Product", price: 10.0) }

    context 'when the product already is in the cart' do
      subject do
        put '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
        put '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        cart_item = create(:cart_item, cart: cart, product: product, quantity: 1)

        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end

  describe 'DELETE /cart' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, name: 'Caneta', price: 10.0) }

    before { create(:cart_item, cart: cart, product: product, quantity: 1) }

    subject { delete "/cart/#{product.id}", as: :json }

    it { expect { subject }.to change { cart.cart_items.count }.by(-1) }
  end
end
