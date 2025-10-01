# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  company_id    :bigint           not null
#  name          :string
#  slug          :string
#  description   :text
#  category_name :string
#  date_start    :date
#  time_start    :time
#  time_end      :time
#  status        :integer          default("active")
#  visible       :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Event < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  enum :status, { active: 0, canceled: 1 }

  # Associations
  belongs_to :company

  has_one :address, as: :addressable
  has_one :banner, as: :photoable, class_name: 'Photo'

  has_many :tickets, dependent: :destroy

  # Validations
  validates :category_name, :date_start, :time_start, presence: true
  validates :time_end, comparison: { greater_than: :time_start }
  validate :check_amount_of_tickets

  accepts_nested_attributes_for :address, allow_destroy: true
  accepts_nested_attributes_for :tickets, allow_destroy: true
  accepts_nested_attributes_for :banner, allow_destroy: true

  # Ransack
  def self.ransackable_attributes(_auth_object = nil)
    %w[name description category_name status]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[]
  end

  def toggle_visible!
    update(visible: !visible)
  end

  def local_name
    address.address_name
  end

  def total_receipt
    tickets.sum(&:tickets_receipt)
  end

  def subscribers_expected
    tickets.sum(&:quantity)
  end

  def subscribers_sellout
    tickets.sum(&:tickets_sellout)
  end

  def tickets_sells_verbose
    "#{subscribers_sellout} / #{subscribers_expected}"
  end
  

  def check_amount_of_tickets
    return unless tickets.count { |t| !t.free_ticket? } > 3

    errors.add :base, 'Evento pode ter no máximo 3 ingressos pagos'
  end

end
