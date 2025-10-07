class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.string :slug
      t.text :description
      t.string :categories, array: true, default: []
      t.date :date_start
      t.time :time_start
      t.time :time_end
      t.integer :status, default: 0
      t.boolean :visible, default: false

      t.timestamps
    end
  end
end
