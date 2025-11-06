# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  addressable_id   :string
#  addressable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  street           :string
#  number           :string
#  neighborhood     :string
#  city             :string
#  state            :string
#  zip_code         :string
#  complement       :string
#
class Address < ApplicationRecord
  STATE_UF = %w[
    AC AL AP AM BA CE DF ES GO MA
    MT MS MG PA PB PR PE PI RJ RN
    RS RO RR SC SP SE TO
  ].freeze

  belongs_to :addressable, polymorphic: true

  def full_address
    [street, number, neighborhood, city, state, zip_code, complement].compact.join(', ')
  end

  def full_info
    "#{street}. #{number}, #{neighborhood}"
  end
end
