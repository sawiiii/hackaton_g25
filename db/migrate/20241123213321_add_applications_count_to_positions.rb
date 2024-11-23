class AddApplicationsCountToPositions < ActiveRecord::Migration[8.0]
  def change
    add_column :positions, :applications_count, :integer, default: 0, null: false
  end
end
