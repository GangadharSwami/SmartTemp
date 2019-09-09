class CreateStudentNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :student_notifications do |t|
      t.belongs_to :student
      t.belongs_to :notification
      t.timestamps
    end
  end
end
