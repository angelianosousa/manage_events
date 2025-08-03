class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.references :event, null: false, foreign_key: true
      t.string :name
      t.integer :quantity, default: 1
      t.monetize :price, default: 0

      t.timestamps
    end
  end
end
