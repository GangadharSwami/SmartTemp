class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.integer   :roll_number, null: false
      t.string    :name, null: false
      t.string    :mother_name, null: false
      t.date      :date_of_birth
      t.integer   :gender, null: false, default: 0
      t.decimal   :tenth_marks
      t.string    :contact
      t.string    :parent_mobile_number, null: false
      t.boolean   :deleted
      t.string    :api_key, null: false
      t.integer   :student_id, null: false

      t.timestamps null: false
    end
  end
end
