# == Schema Information
#
# Table name: payments
#
#  id               :bigint           not null, primary key
#  company_id       :bigint           not null
#  user_account_id  :bigint           not null
#  paymentable_id   :integer
#  paymentable_type :string
#  price_cents      :integer          default(0), not null
#  price_currency   :string           default("BRL"), not null
#  quantity         :integer
#  due_date         :date
#  payment_method   :integer          default("pix")
#  status           :integer          default("pending")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Payment < ApplicationRecord
  enum :payment_method, { pix: 0, credit: 1, debit: 2 }
  enum :status, { pending: 0, paid: 1 }

  monetize :price_cents

  belongs_to :paymentable, polymorphic: true
  belongs_to :company
  belongs_to :ticket, foreign_key: :paymentable_id
  belongs_to :client, class_name: 'Client', foreign_key: :user_account_id

  accepts_nested_attributes_for :client, reject_if: :all_blank

  scope :tickets, -> { where(paymentable_type: 'Ticket') }

  def total
    price * quantity
  end
end
