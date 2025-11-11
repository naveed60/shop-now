class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :price_cents, null: false, default: 0
      t.integer :stock, null: false, default: 0
      t.string :image_url, null: false, default: ""
      t.boolean :featured, null: false, default: false
      t.references :category, null: false, foreign_key: true
      t.jsonb :details, null: false, default: {}

      t.timestamps
    end

    add_index :products, :name
    add_index :products, :featured
  end
end
