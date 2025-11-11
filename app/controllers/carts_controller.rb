class CartsController < ApplicationController
  before_action :authenticate_user!, only: :checkout

  def show
    @cart = Cart.includes(cart_items: :product).find(current_cart.id)
  end

  def add_item
    product = Product.find(params[:product_id])
    quantity = params.fetch(:quantity, 1).to_i

    if current_cart.add_product(product, quantity)
      redirect_back fallback_location: products_path, notice: "#{product.name} was added to your cart."
    else
      redirect_back fallback_location: product_path(product), alert: "Only #{product.stock} left in stock."
    end
  end

  def update_item
    cart_item = current_cart.cart_items.find(params[:id])
    quantity = params.fetch(:quantity, cart_item.quantity).to_i

    if quantity > cart_item.product.stock
      redirect_to cart_path, alert: "Only #{cart_item.product.stock} units of #{cart_item.product.name} available." and return
    end

    if quantity <= 0
      cart_item.destroy
    else
      cart_item.update(quantity:)
    end

    redirect_to cart_path, notice: "Cart updated."
  end

  def remove_item
    cart_item = current_cart.cart_items.find(params[:id])
    cart_item.destroy

    redirect_to cart_path, notice: "Item removed from your cart."
  end

  def checkout
    cart = Cart.includes(cart_items: :product).find(current_cart.id)

    if cart.cart_items.none?
      redirect_to products_path, alert: "Add a product before checking out." and return
    end

    shipping_address = checkout_params[:shipping_address].presence || "#{current_user.first_name} #{current_user.last_name}".strip

    ActiveRecord::Base.transaction do
      cart.update!(status: :ordered, user: current_user)
      Order.create!(
        cart: cart,
        user: current_user,
        total_cents: cart.total_cents,
        status: :submitted,
        shipping_address: shipping_address
      )
    end

    session[:cart_id] = nil
    redirect_to root_path, notice: "Thanks! Your order is confirmed."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to cart_path, alert: e.record.errors.full_messages.to_sentence
  end

  private

  def checkout_params
    params.fetch(:checkout, {}).permit(:shipping_address)
  end
end
