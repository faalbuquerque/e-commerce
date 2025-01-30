class RemoveExpiredCartsJob
  include Sidekiq::Job

  def perform
    Cart.where(status: :abandoned, updated_at: ..(DateTime.now + Cart::REMOVE_CONSIDERED_ABANDONED_TIMESPACE)).destroy_all
  end
end
