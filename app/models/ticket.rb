# == Schema Information
#
# Table name: tickets
#
#  id             :bigint           not null, primary key
#  event_id       :bigint           not null
#  name           :string
#  description    :string
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
  has_many :payments, as: :paymentable, dependent: :destroy

  # Validations
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { greater_than: 0 }

  def tickets_percentage
    {
      total: tickets_sellout.to_f / quantity * 100,
      paid: payments.paid.count.to_f / quantity * 100
    }
  end

  def free_ticket?
    price == Money.new(0)
  end

  def tickets_sellout
    payments.sum(&:quantity)
  end

  def tickets_receipt
    tickets_sellout * price
  end

end
