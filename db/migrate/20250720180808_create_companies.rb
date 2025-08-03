class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :slug
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
