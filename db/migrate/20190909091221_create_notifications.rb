class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string  :title
      t.string  :description
      t.boolean :deleted, default: false
      t.timestamps
    end
  end
end
