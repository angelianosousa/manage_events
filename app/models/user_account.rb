# == Schema Information
#
# Table name: user_accounts
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  company_id             :bigint
#  type                   :string           not null
#  phone                  :string
#  cpf                    :string
#
class UserAccount < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable, :trackable, :validatable and :omniauthable
  devise :database_authenticatable

  belongs_to :company
end
