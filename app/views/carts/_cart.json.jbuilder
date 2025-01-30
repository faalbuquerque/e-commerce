json.id             cart.id

json.products cart.cart_items do |cart_item|
  json.id           cart_item.product.id
  json.name         cart_item.product.name
  json.quantity     cart_item.quantity
  json.unit_price   cart_item.product.price
  json.total_price  cart_item.total_price
end

json.total_price    cart.total_price