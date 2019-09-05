class CreateAttendanceLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :attendance_logs do |t|
      t.integer :roll_number, null: false
      t.date    :log_date, null: false
      t.integer :log_time, null: false
      t.timestamps null: false
    end
  end
end
