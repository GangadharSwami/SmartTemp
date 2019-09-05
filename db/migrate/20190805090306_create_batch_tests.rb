class CreateBatchTests < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_tests do |t|
      t.belongs_to :batch
      t.belongs_to :test
      t.timestamps null: false
    end
  end
end
