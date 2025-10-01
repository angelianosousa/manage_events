class AddFieldsToCompany < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :email, :string
    add_column :companies, :site, :string
    add_column :companies, :phone, :string
    add_column :companies, :cellphone, :string
  end
end
