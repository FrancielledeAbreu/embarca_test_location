class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.references :state, foreign_key: true
      t.string :name, null: false
      t.string :acronym, null: false
      t.string :country

      t.timestamps
    end
  end
end
