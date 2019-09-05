class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.string  :name, null: false
      t.text    :description
      t.date    :test_date
      t.integer :no_of_questions
      t.integer :total_marks
      t.integer :passing_marks
      t.string  :answer_key
      t.boolean :is_theory, null: false, default: false
      t.boolean :is_combined, null: false, default: false
      t.string  :question_paper_link
      t.string  :answer_paper_link
      
      t.timestamps null: false
    end
  end
end
