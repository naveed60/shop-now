require "securerandom"

class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  has_one :order, dependent: :nullify

  enum :status, { active: 0, ordered: 1 }

  before_validation :ensure_token

  def add_product(product, quantity = 1)
    return false unless quantity.positive? && active?

    cart_item = cart_items.find_or_initialize_by(product: product)
    new_quantity = cart_item.quantity.to_i + quantity
    return false if new_quantity > product.stock

    cart_item.unit_price_cents = product.price_cents
    cart_item.quantity = new_quantity
    cart_item.save
  end

  def total_cents
    cart_items.sum(Arel.sql("quantity * unit_price_cents"))
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def empty?
    cart_items.none?
  end

  private

  def ensure_token
    self.token ||= SecureRandom.uuid
  end
end
