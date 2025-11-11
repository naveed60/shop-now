class Order < ApplicationRecord
  belongs_to :user
  belongs_to :cart

  enum :status, { submitted: 0, fulfilled: 1, cancelled: 2 }

  validates :shipping_address, presence: true
  validates :total_cents, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[user_id cart_id status total_cents shipping_address created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user cart]
  end
end
