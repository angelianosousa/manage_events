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
class Client < UserAccount
  validates :cpf, uniqueness: true, presence: true
  validates :name, :phone, presence: true
  validates :email, uniqueness: true, format: Devise.email_regexp
  validate :cpf_validation

  def cpf=(value)
    super(value.gsub(/\D/, ''))
  end

  def cpf_formatted
    return if cpf.blank?

    CPF.new(cpf).formatted
  end

  def cpf_validation
    return unless cpf.blank?

    errors.add :cpf, :invalid unless CPF.valid?(cpf)
  end

end
