class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 17, scale: 2, default: 0

      t.timestamps
    end
  end
end
