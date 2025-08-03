class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :place_name
      t.string :address_name
      t.string :addressable_id
      t.string :addressable_type

      t.timestamps
    end
  end
end
