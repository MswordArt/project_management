class CreateResponsibles < ActiveRecord::Migration[5.2]
  def change
    create_table :responsibles do |t|
      t.references :task, foreign_key: true, null: false

      t.timestamps
    end
  end
end
