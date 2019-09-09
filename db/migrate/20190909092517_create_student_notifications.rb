class CreateStudentNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :student_notifications do |t|
      t.belongs_to :students
      t.belongs_to :notifications
      t.timestamps
    end
  end
end
