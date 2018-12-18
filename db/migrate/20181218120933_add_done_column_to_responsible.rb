class AddDoneColumnToResponsible < ActiveRecord::Migration[5.2]
  def change
    add_column :responsibles, :done, :boolean, default: false
  end
end
