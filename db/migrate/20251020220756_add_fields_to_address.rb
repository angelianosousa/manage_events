class AddFieldsToAddress < ActiveRecord::Migration[7.1]
  def up
    add_column :addresses, :street, :string
    add_column :addresses, :number, :string
    add_column :addresses, :neighborhood, :string
    add_column :addresses, :city, :string
    add_column :addresses, :state, :string
    add_column :addresses, :zip_code, :string
    add_column :addresses, :complement, :string

    remove_column :addresses, :place_name
    remove_column :addresses, :address_name
  end

  def down
    remove_column :addresses, :street
    remove_column :addresses, :number
    remove_column :addresses, :neighborhood
    remove_column :addresses, :city
    remove_column :addresses, :state
    remove_column :addresses, :zip_code
    remove_column :addresses, :complement

    add_column :addresses, :place_name, :string
    add_column :addresses, :address_name, :string
  end
end
