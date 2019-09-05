# == Schema Information
#
# Table name: batch_students
#
#  id         :integer          not null, primary key
#  batch_id   :integer
#  student_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_batch_students_on_batch_id    (batch_id)
#  index_batch_students_on_student_id  (student_id)
#

class BatchStudent < ApplicationRecord
  belongs_to :batch
  belongs_to :student
end
