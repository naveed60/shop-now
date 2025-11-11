class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)
    @catalog_size = Product.count
    @filters = filter_params
    @featured_product = Product.featured.order(Arel.sql("RANDOM()")).first || Product.order(created_at: :desc).first
    @starting_price_cents = Product.minimum(:price_cents) || 0
    @products = Product.filtered_by(@filters).includes(:category).order(featured: :desc, created_at: :desc)
    @hero_slides = hero_slides_payload
  end

  def show
    @product = Product.find(params[:id])
    @related_products = Product.where(category_id: @product.category_id).where.not(id: @product.id).limit(4)
  end

  private

  def filter_params
    params.permit(:query, :category_id, :min_price, :max_price, :only_featured)
  end

  def hero_slides_payload
    [
      {
        title: "11.11 Fashion-Tech Sale",
        subtitle: "Smart wearables starting from Rs. 4,999",
        cta_text: "Live Now",
        cta_link: products_path,
        badge: "Biggest drop of the year",
        image_url: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=80",
        accent: "from-purple-700 via-fuchsia-600 to-pink-500"
      },
      {
        title: "Zero Earbuds Ultra",
        subtitle: "Noise cancelling buds with studio tuned sound.",
        cta_text: "Shop Earbuds",
        cta_link: products_path(category_id: Category.find_by(name: "Modern Workspace")&.id),
        badge: "New drop",
        image_url: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=80",
        accent: "from-indigo-700 via-blue-600 to-sky-500"
      },
      {
        title: "Pro Audio Essentials",
        subtitle: "Bundle up studio monitors & creators gear with 70% off.",
        cta_text: "Build your setup",
        cta_link: products_path,
        badge: "Creator picks",
        image_url: "https://images.unsplash.com/photo-1484704849700-f032a568e944?auto=format&fit=crop&w=900&q=80",
        accent: "from-amber-500 via-orange-500 to-rose-500"
      }
    ]
  end
end
