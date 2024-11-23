class CreatePositions < ActiveRecord::Migration[8.0]
  def change
    create_table :positions do |t|
      t.string :name
      t.text :description
      t.integer :vacancies
      t.references :project

      t.timestamps
    end
  end
end
