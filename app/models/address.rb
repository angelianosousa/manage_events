# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  place_name       :string
#  address_name     :string
#  addressable_id   :string
#  addressable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
end
