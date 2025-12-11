ActiveAdmin.register Product do
  permit_params :name, :description, :price_cents, :stock, :image_url, :featured, :category_id, details: {}

  includes :category

  scope :all, default: true
  scope :featured

  index do
    selectable_column
    id_column
    column :name
    column :category
    column("Price") { |product| number_to_currency(product.price_cents / 100.0) }
    column :stock
    column :featured
    actions
  end

  filter :name
  filter :category
  filter :featured
  filter :price_cents, label: "Price (cents)"
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :category
      f.input :description
      f.input :price_cents, label: "Price (cents)"
      f.input :stock
      f.input :image_url
      f.input :featured
      f.input :details
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :category
      row("Price") { number_to_currency(product.price_cents / 100.0) }
      row :stock
      row :featured
      row :image_url
      row :description
      row :details do
        pre JSON.pretty_generate(product.details || {})
      end
      row :created_at
      row :updated_at
    end
  end
end
