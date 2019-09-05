# == Schema Information
#
# Table name: test_students
#
#  id                 :integer          not null, primary key
#  test_id            :integer
#  student_id         :integer
#  student_marks      :integer
#  student_answer_key :string
#  rank               :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class TestStudent < ApplicationRecord
  belongs_to :test
  belongs_to :student
end
