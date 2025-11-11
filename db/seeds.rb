require "faker"

puts "Seeding Shop Now data..."

category_names = [
  "Modern Workspace",
  "Wellness & Rituals",
  "Smart Living",
  "Outdoor Escape",
  "Creative Studio"
]

categories = category_names.map do |name|
  Category.find_or_create_by!(slug: name.parameterize) do |category|
    category.name = name
  end
end

products_data = [
  {
    name: "Nimbus Glass Smart Lamp",
    category: "Modern Workspace",
    price_cents: 189_00,
    stock: 30,
    featured: true,
    image_url: "https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80"
  },
  {
    name: "Luna Air Purifier",
    category: "Smart Living",
    price_cents: 249_00,
    stock: 18,
    featured: true,
    image_url: "https://images.unsplash.com/photo-1580894908361-967195033215?auto=format&fit=crop&w=1200&q=80"
  },
  {
    name: "Solace Meditation Mat",
    category: "Wellness & Rituals",
    price_cents: 129_00,
    stock: 40,
    image_url: "https://images.unsplash.com/photo-1528319722774-0f8dcfead83c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    name: "Arc Studio Monitor Speakers",
    category: "Creative Studio",
    price_cents: 499_00,
    stock: 15,
    featured: true,
    image_url: "https://images.unsplash.com/photo-1478737270239-2f02b77fc618?auto=format&fit=crop&w=1200&q=80"
  },
  {
    name: "Flow Ergonomic Chair",
    category: "Modern Workspace",
    price_cents: 329_00,
    stock: 25,
    image_url: "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80"
  },
  {
    name: "Horizon Cold Brew Kit",
    category: "Creative Studio",
    price_cents: 89_00,
    stock: 50,
    image_url: "https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=1200&q=80"
  },
  {
    name: "Aura Smart Mirror",
    category: "Smart Living",
    price_cents: 379_00,
    stock: 12,
    image_url: "https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=1200&q=80"
  },
  {
    name: "Haven Outdoor Lantern",
    category: "Outdoor Escape",
    price_cents: 149_00,
    stock: 20,
    image_url: "https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=1200&q=80"
  },
  {
    name: "Nomad Travel Tumbler",
    category: "Outdoor Escape",
    price_cents: 49_00,
    stock: 70,
    image_url: "https://images.unsplash.com/photo-1498804103079-a6351b050096?auto=format&fit=crop&w=1200&q=80"
  }
]

products_data.each do |data|
  category = categories.find { |c| c.name == data[:category] }
  Product.find_or_initialize_by(name: data[:name]).tap do |product|
    product.category = category
    product.description = Faker::Marketing.buzzwords.titleize + " crafted for mindful living."
    product.price_cents = data[:price_cents]
    product.stock = data[:stock]
    product.featured = data[:featured] || false
    product.image_url = data[:image_url]
    product.details = { materials: Faker::Commerce.material, warranty: "#{rand(1..3)} years", energy_rating: ["A", "A+", "A++"].sample }
    product.save!
  end
end

demo_user = User.find_or_create_by!(email: "demo@shopnow.test") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.first_name = "Demo"
  user.last_name = "Customer"
end

if Rails.env.development?
  AdminUser.find_or_create_by!(email: "admin@example.com") do |admin|
    admin.password = "password"
    admin.password_confirmation = "password"
  end
end

demo_cart = Cart.find_or_create_by!(token: "demo-cart") do |cart|
  cart.user = demo_user
  cart.status = :active
end
demo_cart.cart_items.destroy_all
Product.limit(3).each do |product|
  demo_cart.cart_items.create!(product: product, quantity: 1, unit_price_cents: product.price_cents)
end
demo_cart.update!(status: :ordered)

Order.find_or_create_by!(cart: demo_cart) do |order|
  order.user = demo_user
  order.total_cents = demo_cart.total_cents
  order.status = :submitted
  order.shipping_address = "123 Modern Blvd, Innovation City"
end

puts "Seed complete!"
