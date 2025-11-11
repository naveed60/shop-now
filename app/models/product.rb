class Product < ApplicationRecord
  belongs_to :category
  has_many :cart_items, dependent: :restrict_with_exception

  validates :name, :description, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  scope :featured, -> { where(featured: true) }
  scope :search, ->(query) { where("products.name ILIKE :q OR products.description ILIKE :q", q: "%#{query}%") }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name description price_cents stock featured category_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category cart_items]
  end

  BADGE_PRESETS = [
    "TRENDING",
    "LIMITED DROP",
    "BEST VALUE",
    "70HRS PLAYTIME",
    "HEAVY BASS"
  ].freeze

  def price
    price_cents.to_i / 100.0
  end

  def formatted_price
    ActionController::Base.helpers.number_to_currency(price)
  end

  def showcase_badge
    details["badge"].presence || BADGE_PRESETS[derived_random(1).rand(BADGE_PRESETS.size)]
  end

  def rating_score
    stored = details["rating"]
    return stored.to_f.round(2) if stored.present?

    (4.2 + derived_random(2).rand * 0.7).round(2)
  end

  def discount_percentage
    stored = details["discount"]
    return stored.to_i if stored.present?

    [60, 65, 70, 75, 80].sample(random: derived_random(3))
  end

  def original_price_cents
    stored = details["original_price_cents"]
    return stored.to_i if stored.present?

    (price_cents / (1 - discount_percentage / 100.0)).round(-1)
  end

  def accent_colors
    stored = Array(details["colors"]).presence
    return stored if stored.present?

    palettes = [
      %w[#5C2EFF #DFE2FF #E9D5FF],
      %w[#F97316 #FED7AA #FFE4E6],
      %w[#0EA5E9 #CFFAFE #E0F2FE],
      %w[#10B981 #D1FAE5 #ECFDF5]
    ]
    palettes.sample(random: derived_random(4))
  end

  def color_swatches
    (details["swatches"] || ["#111827", "#6B7280", accent_colors.first]).take(3)
  end

  def hero_caption
    details["subtitle"].presence || "#{category.name} · #{stock} in stock"
  end

  def self.filtered_by(filters = {})
    scope = includes(:category).all
    scope = scope.search(filters[:query]) if filters[:query].present?
    scope = scope.where(category_id: filters[:category_id]) if filters[:category_id].present?

    if filters[:min_price].present?
      scope = scope.where("price_cents >= ?", (filters[:min_price].to_f * 100).to_i)
    end

    if filters[:max_price].present?
      scope = scope.where("price_cents <= ?", (filters[:max_price].to_f * 100).to_i)
    end

    scope = scope.featured if ActiveModel::Type::Boolean.new.cast(filters[:only_featured])
    scope
  end

  private

  def derived_random(offset)
    Random.new((id || name.hash).to_i + offset)
  end
end
