FactoryBot.define do
  factory :cart do
    total_price { 150.0 }
    cart_items { build_list(:cart_item, 3) }

    trait :with_many_items do
      cart_items { build_list(:cart_item, 10) }
    end

    trait :empty do
      cart_items { [] }
    end
  end
end
