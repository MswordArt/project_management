class AddProgressColumnToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :progress, :float, default: 0.0
  end
end
