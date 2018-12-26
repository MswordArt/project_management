class AddViewedColumnToResponsible < ActiveRecord::Migration[5.2]
  def change
    add_column :responsibles, :viewed, :boolean, default: false
  end
end
