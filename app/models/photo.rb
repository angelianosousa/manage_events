# == Schema Information
#
# Table name: photos
#
#  id             :bigint           not null, primary key
#  photoable_id   :integer
#  photoable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Photo < ApplicationRecord
  belongs_to :photoable, polymorphic: true

  has_one_attached :image do |attachable|
    attachable.variant :banner, resize_to_limit: [1320, 300]
  end
end
