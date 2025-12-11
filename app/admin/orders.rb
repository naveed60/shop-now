ActiveAdmin.register Order do
  actions :all, except: %i[new destroy]

  includes cart: { cart_items: :product }

  permit_params :status, :shipping_address

  scope :all, default: true
  scope :submitted
  scope :fulfilled
  scope :cancelled

  index do
    selectable_column
    id_column
    column :user
    column :status do |order|
      status_tag(order.status)
    end
    column("Items") { |order| order.cart.cart_items.count }
    column("Total") { |order| number_to_currency(order.total_cents / 100.0) }
    column :created_at
    actions
  end

  filter :status
  filter :user
  filter :created_at

  action_item :fulfill, only: :show, if: proc { resource.submitted? } do
    link_to "Mark as fulfilled", fulfill_admin_order_path(resource), method: :put
  end

  action_item :cancel, only: :show, if: proc { resource.submitted? } do
    link_to "Cancel order", cancel_admin_order_path(resource), method: :put, data: { confirm: "Are you sure you want to cancel this order?" }
  end

  member_action :fulfill, method: :put do
    if resource.submitted?
      resource.update(status: :fulfilled)
      redirect_to resource_path, notice: "Order marked as fulfilled."
    else
      redirect_to resource_path, alert: "Only submitted orders can be fulfilled."
    end
  end

  member_action :cancel, method: :put do
    if resource.submitted?
      resource.update(status: :cancelled)
      redirect_to resource_path, notice: "Order cancelled."
    else
      redirect_to resource_path, alert: "Only submitted orders can be cancelled."
    end
  end

  show do
    attributes_table do
      row :id
      row :user
      row :status do
        status_tag(order.status)
      end
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

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :status, as: :select, collection: Order.statuses.keys
      f.input :shipping_address
    end
    f.actions
  end
end
