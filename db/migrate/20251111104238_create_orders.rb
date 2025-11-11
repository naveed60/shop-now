class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cart, null: false, foreign_key: true
      t.integer :total_cents, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.string :shipping_address, null: false, default: ""

      t.timestamps
    end

    add_index :orders, :status
  end
end
