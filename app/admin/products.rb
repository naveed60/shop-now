ActiveAdmin.register Product do
  permit_params :name, :description, :price_cents, :stock, :image_url, :featured, :category_id, details: {}

  includes :category

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
end
