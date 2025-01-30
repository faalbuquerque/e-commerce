FactoryBot.define do
  factory :cart_item do
    product { association :product }
    quantity { 1 }

    trait :with_high_quantity do
      quantity { 50 }
    end
  end
end
