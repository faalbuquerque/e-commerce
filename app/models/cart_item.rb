class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  def total_price
    quantity * product.price
  end

  def adjust_quantity(value)
    AdjustCartItemQuantityService.call(cart_item_id: self.id, new_quantity: value)
  end
end
