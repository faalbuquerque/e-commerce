class ExpireCartService
  def initialize(**args)
    @cart = Cart.find(args[:cart_id])
  end

  def self.call(**args)
    new(**args).call
  end

  def call
    run
  end

  private

  def run
    try_set_abandoned_cart
  end

  def try_set_abandoned_cart
    return if stop_tracking_cart?

    due_time = @cart.updated_at + Cart::CONSIDERED_ABANDONED_TIMESPACE
    @cart.abandoned! if due_time < DateTime.now
    @cart.generate_expire_job
  end

  def stop_tracking_cart?
    @cart.nil? || !(@cart.active? || @cart.abandoned?)
  end
end
