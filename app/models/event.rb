# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  company_id    :bigint           not null
#  name          :string
#  description   :text
#  category_name :string
#  date_start    :datetime
#  date_end      :datetime
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Event < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  enum :status, { active: 0, finished: 1, canceled: 2 }

  # Associations
  belongs_to :company

  has_one :address, as: :addressable
  has_one :banner, as: :photoable, class_name: 'Photo'

  has_many :tickets, dependent: :destroy

  # Validations
  validates :category_name, :date_start, :time_start, presence: true
  validates :time_end, comparison: { greater_than: :time_start }

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

end
