class AddFieldsToPayment < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :cancelled_at, :datetime
    add_column :payments, :expired_at, :datetime
    add_column :payments, :paided_at, :datetime
  end
end
