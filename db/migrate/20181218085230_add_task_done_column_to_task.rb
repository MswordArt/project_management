class AddTaskDoneColumnToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :task_done, :boolean, default: false
    add_column :tasks, :done_at, :date
  end
end
