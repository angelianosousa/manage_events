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
#
class Company < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  # Associations
  has_many :admins
  has_many :events

  # Validations
  validates :name, presence: true
end
