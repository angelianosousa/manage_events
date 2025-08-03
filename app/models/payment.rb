# == Schema Information
#
# Table name: payments
#
#  id               :bigint           not null, primary key
#  company_id       :bigint           not null
#  user_account_id  :bigint           not null
#  paymentable_id   :integer
#  paymentable_type :string
#  due_date         :date
#  payment_method   :integer
#  status           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Payment < ApplicationRecord
  enum :payment_method, { pix: 0, cash: 1, credit: 2, debit: 3 }
  enum :status, { pending: 0, paid: 1, overdue: 2 }

  monetize :price_cents

  belongs_to :paymentable, polymorphic: true
  belongs_to :company
  belongs_to :client, class_name: 'UserAccount', foreign_key: :user_account_id

  scope :tickets, -> { where(paymentable_type: 'Ticket') }
end
