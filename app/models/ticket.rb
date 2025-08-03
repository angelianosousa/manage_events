# == Schema Information
#
# Table name: tickets
#
#  id             :bigint           not null, primary key
#  event_id       :bigint           not null
#  quantity       :integer          default(1)
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("BRL"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Ticket < ApplicationRecord
  belongs_to :event

  monetize :price_cents

  # Associations
  has_many :ticket_payments, as: :paymentable, dependent: :destroy, class_name: 'Payment'

  # Validations
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { greater_than: 0 }

  def tickets_percentage
    {
      total: ticket_payments.count.to_f / quantity * 100,
      paid: ticket_payments.paid.count.to_f / quantity * 100
    }
  end

  def tickets_receipt
    ticket_payments.count * price
  end

end
