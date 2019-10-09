# == Schema Information
#
# Table name: tests
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  description         :text
#  test_date           :date
#  no_of_questions     :integer
#  total_marks         :integer
#  passing_marks       :integer
#  answer_key          :string
#  is_theory           :boolean          default(FALSE), not null
#  is_combined         :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  question_paper_link :string
#  answer_paper_link   :string
#

class Test < ApplicationRecord
  has_many :test_students
  has_many :students, through: :test_students

  has_many :batch_tests
  has_many :batches, through: :batch_tests

  mount_uploader :question_paper_link, PdfUploader
  mount_uploader :answer_paper_link, PdfUploader

  def get_toppers(limit, test_id)
    rank_details = TestStudent.where(test_id: test_id).select('test_id, student_id, student_marks, rank() OVER (PARTITION BY test_id ORDER BY student_marks DESC) AS rank').limit(limit)
    topper_ids = rank_details.collect { |rank| rank["student_id"] }
    topper_students = Student.where(id: topper_ids).index_by(&:id)

    toppers_list = rank_details.map{ |rank_data|
      student = topper_students[rank_data['student_id'].to_i]
      {
        name: (student.name.humanize rescue ''),
        marks_obtained: rank_data['student_marks'],
        total_marks: self.total_marks,
        batch: student.batches.pluck(:name).join(', '),
        rank: rank_data['rank'].to_i,
        image_url: ""
      } unless student.nil?
    } 
    return toppers_list
  end
  
end
