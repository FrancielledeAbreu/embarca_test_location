class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.string :name, null: false
      t.integer :country, default: 1, null: false

      t.timestamps
    end
  end
end
