class CartsController < ApplicationController
  before_action :set_cart, only: %i[create destroy update]
  before_action :fetch_cart_item, only: %i[destroy update]

  def show
    @cart = Cart.includes(cart_items: :product).where(id: session[:cart_id]).first
  end

  def create
    cart_item = @cart.cart_items.find_or_create_by(product_id: params[:product_id])
    return render json: {}, status: :not_found unless cart_item.valid?

    cart_item.adjust_quantity(params[:quantity])
  end

  def destroy
    @cart_item.destroy if @cart_item
  end

  def update
    @cart_item.adjust_quantity(params[:quantity])
  end

  private

  def fetch_cart_item
    @cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    return render json: {}, status: :not_found if @cart_item.nil?
  end

  def set_cart
    @cart = Cart.find_or_initialize_by(id: session[:cart_id])
    @cart.save && (session[:cart_id] = @cart.id) if @cart.new_record?
  end

  def product_params
    params.require(:cart).permit(:total_price)
  end
end
