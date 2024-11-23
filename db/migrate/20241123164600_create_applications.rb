class CreateApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :applications do |t|
      t.text :motivation
      t.references :position
      t.references :person
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
