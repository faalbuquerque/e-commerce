class AdjustCartItemQuantityService
  def initialize(**args)
    @cart_item = CartItem.find(args[:cart_item_id])
    @cart = @cart_item.cart
    @new_quantity = args[:new_quantity]
  end

  def self.call(**args)
    new(**args).call
  end

  def call
    run
  end

  private

  def run
    update_quantity
    update_cart_status
  end

  def update_quantity
    @new_quantity = @cart_item.quantity + @new_quantity.to_i
    @new_quantity = @new_quantity <= 0 ? 0 : @new_quantity
    @cart_item.update(quantity: @new_quantity)
  end

  def update_cart_status
    @cart.touch
    @cart.active!
  end
end
