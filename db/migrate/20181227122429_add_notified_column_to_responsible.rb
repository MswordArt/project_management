class AddNotifiedColumnToResponsible < ActiveRecord::Migration[5.2]
  def change
    add_column :responsibles, :notified, :boolean, default: false
  end
end
