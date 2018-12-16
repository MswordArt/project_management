class AddUserIdToResponsible < ActiveRecord::Migration[5.2]
  def change
    add_column :responsibles, :user_id, :integer, null: false
  end
end
