class AddSourceIdToPayment < ActiveRecord::Migration[7.1]
  def up
    add_column :payments, :source_id, :string
    add_column :payments, :link, :string
    add_column :payments, :token_pay, :string, null: false
    add_column :payments, :cancelled_at, :datetime
    add_column :payments, :expired_at, :datetime
    add_column :payments, :paided_at, :datetime

    # remove_column :payments, :due_date, :date
    remove_column :payments, :payment_method, :integer

    add_column :companies, :asaas_api_key, :string
    add_column :companies, :asaas_webhook_token, :string, null: false

    add_index :payments, :token_pay, unique: true
    add_index :companies, :asaas_webhook_token, unique: true

    Company.update_all(asaas_webhook_token: SecureRandom.base58)
    Payment.update_all(token_pay: SecureRandom.base58)
  end

  def down
    remove_column :payments, :source_id, :string
    remove_column :payments, :link, :string
    remove_column :payments, :token_pay, :string, null: false
    remove_column :payments, :cancelled_at, :datetime
    remove_column :payments, :expired_at, :datetime
    remove_column :payments, :paided_at, :datetime

    # add_column :payments, :due_date, :date
    add_column :payments, :payment_method, :integer

    remove_column :companies, :asaas_api_key, :string
    remove_column :companies, :asaas_webhook_token, :string
  end
end
