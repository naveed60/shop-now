class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }

  before_validation :set_unit_price_cents, on: :create

  delegate :name, :image_url, :price_cents, to: :product

  def subtotal_cents
    quantity * unit_price_cents
  end

  private

  def set_unit_price_cents
    self.unit_price_cents ||= product.price_cents
  end
end
