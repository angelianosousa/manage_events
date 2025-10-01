# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string
#  site       :string
#  phone      :string
#  cellphone  :string
#
class Company < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  # Associations
  has_many :admins, class_name: 'Admin', dependent: :destroy
  has_many :clients, class_name: 'Client', dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_one :admin_base, class_name: 'Admin', dependent: :destroy
  has_one :logo, as: :photoable, class_name: 'Photo'

  # Validations
  validates :name, presence: true

  accepts_nested_attributes_for :admin_base, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :logo, allow_destroy: true
end
