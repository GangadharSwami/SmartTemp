class AddNotificationTokenToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :notification_token, :string
  end
end
