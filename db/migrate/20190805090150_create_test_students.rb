class CreateTestStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :test_students do |t|
      t.belongs_to  :test
      t.belongs_to  :student
      t.integer     :student_marks
      t.string      :student_answer_key
      t.integer     :rank

      t.timestamps null: false
    end
  end
end
