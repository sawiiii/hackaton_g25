class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.references :owner, foreign_key: { to_table: :people }

      t.timestamps
    end
  end
end
