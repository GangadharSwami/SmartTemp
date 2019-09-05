class CreateBatchStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_students do |t|
      t.belongs_to :batch, index: :true
      t.belongs_to :student, index: :true
      t.timestamps null: false
    end
  end
end
