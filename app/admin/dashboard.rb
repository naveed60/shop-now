# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Sales overview" do
          total_revenue_cents = Order.fulfilled.sum(:total_cents)
          total_orders = Order.count
          submitted_count = Order.submitted.count
          fulfilled_count = Order.fulfilled.count
          cancelled_count = Order.cancelled.count

          para "Total revenue (fulfilled): #{number_to_currency(total_revenue_cents / 100.0)}"
          para "Total orders: #{total_orders}"
          para "Submitted: #{submitted_count}, Fulfilled: #{fulfilled_count}, Cancelled: #{cancelled_count}"

          if fulfilled_count.positive?
            average_order_value_cents = total_revenue_cents / fulfilled_count
            para "Average order value (fulfilled): #{number_to_currency(average_order_value_cents / 100.0)}"
          end
        end
      end

      column do
        panel "Recent orders" do
          table_for Order.order(created_at: :desc).limit(10) do
            column :id
            column :user
            column :status do |order|
              status_tag(order.status)
            end
            column("Total") { |order| number_to_currency(order.total_cents / 100.0) }
            column :created_at
          end
        end
      end
    end

    columns do
      column do
        panel "Top products" do
          top_products = Product.joins(cart_items: { cart: :order })
                                .merge(Order.fulfilled)
                                .select("products.*, SUM(cart_items.quantity) AS quantity_sold, SUM(cart_items.quantity * cart_items.unit_price_cents) AS revenue_cents")
                                .group("products.id")
                                .order("revenue_cents DESC")
                                .limit(5)

          if top_products.any?
            table_for top_products do
              column :name
              column("Quantity sold") { |product| product.quantity_sold }
              column("Revenue") { |product| number_to_currency(product.revenue_cents.to_i / 100.0) }
            end
          else
            para "No fulfilled orders yet."
          end
        end
      end

      column do
        panel "Low stock products" do
          low_stock_products = Product.order(:stock).limit(10)

          if low_stock_products.any?
            table_for low_stock_products do
              column :name
              column :category
              column :stock
            end
          else
            para "No products found."
          end
        end
      end
    end
  end # content
end
