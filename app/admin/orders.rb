ActiveAdmin.register Order do
  actions :all, except: %i[new edit destroy]

  includes cart: { cart_items: :product }

  permit_params :status

  index do
    selectable_column
    id_column
    column :user
    column :status
    column("Items") { |order| order.cart.cart_items.count }
    column("Total") { |order| number_to_currency(order.total_cents / 100.0) }
    column :created_at
    actions
  end

  filter :status
  filter :user
  filter :created_at

  show do
    attributes_table do
      row :id
      row :user
      row :status
      row :shipping_address
      row("Total") { number_to_currency(order.total_cents / 100.0) }
      row :created_at
    end

    panel "Items" do
      table_for order.cart.cart_items do
        column :product
        column :quantity
        column("Subtotal") { |item| number_to_currency(item.subtotal_cents / 100.0) }
      end
    end
  end
end
