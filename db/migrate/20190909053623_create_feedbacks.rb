class CreateFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :feedbacks do |t|
      t.belongs_to :student, index: :true
      t.string    :name
      t.string    :mobile_number
      t.string    :feedback
      t.timestamps
    end
  end
end
