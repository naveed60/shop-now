class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_exception

  validates :name, :slug, presence: true, uniqueness: true

  before_validation :assign_slug, if: -> { slug.blank? && name.present? }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name slug created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[products]
  end

  private

  def assign_slug
    self.slug = name.parameterize
  end
end
