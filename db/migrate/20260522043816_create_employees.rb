class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :position
      t.decimal :salary, precision: 20, scale: 2

      t.timestamps
    end
  end
end
