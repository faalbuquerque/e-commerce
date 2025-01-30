class Cart < ApplicationRecord
  after_create :generate_expire_job

  CONSIDERED_ABANDONED_TIMESPACE = 3.hours
  REMOVE_CONSIDERED_ABANDONED_TIMESPACE = 7.days

  has_many :cart_items, dependent: :destroy

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  enum status: { active: 10, abandoned: 20 }

  def total_price
    cart_items.sum { _1.total_price }
  end

  def generate_expire_job
    ExpireCartsJob.perform_in(CONSIDERED_ABANDONED_TIMESPACE, self.id)
  end
end
