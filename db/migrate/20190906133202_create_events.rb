class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.date   :event_date
      t.boolean :deleted
      t.timestamps
    end
  end
end
