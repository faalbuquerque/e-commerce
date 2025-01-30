class ExpireCartsJob
  include Sidekiq::Job

  def perform(cart_id)
    ExpireCartService.call(cart_id: cart_id)
  end
end
