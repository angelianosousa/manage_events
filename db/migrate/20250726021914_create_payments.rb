class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :company, null: false, foreign_key: true
      t.references :user_account, null: false, foreign_key: true
      t.integer :paymentable_id
      t.string :paymentable_type
      t.monetize :price
      t.integer :quantity
      t.date :due_date
      t.integer :payment_method, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
