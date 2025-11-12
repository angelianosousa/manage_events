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
#  source_id        :string
#  link             :string
#
class Payment < ApplicationRecord
  has_secure_token :token_pay, length: 36
  enum :status, { pending: 0, paid: 1, cancelled: 2, expired: 3 }

  monetize :price_cents

  belongs_to :paymentable, polymorphic: true
  belongs_to :company
  belongs_to :ticket, foreign_key: :paymentable_id
  belongs_to :client, class_name: 'Client', foreign_key: :user_account_id

  validates :source_id, presence: true, uniqueness: { scope: :company_id }

  accepts_nested_attributes_for :client, reject_if: :all_blank

  scope :tickets, -> { where(paymentable_type: 'Ticket') }

  def total
    price * quantity
  end

  def confirm_sub!
    SubsMailer.with(payment: self).subs_confirm.deliver_later
  end

  def confirm_sub_success!
    return if paided_at.present?

    SubsMailer.with(payment: self).subs_success.deliver_later
    update(paided_at: DateTime.now, status: :paid)
  end

  def cancel_sub!
    return if cancelled_at.present?

    SubsMailer.with(payment: self).subs_cancel.deliver_later
    update(cancelled_at: DateTime.now, status: :cancelled)
  end

  def expire_sub!
    return if expired_at.present?

    update(expireed_at: DateTime.now, status: :expired)
  end
end
