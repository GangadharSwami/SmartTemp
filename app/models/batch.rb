# == Schema Information
#
# Table name: batches
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Batch < ApplicationRecord
  has_many :batch_students
  has_many :students, through: :batch_students

  has_many :batch_tests
  has_many :tests, through: :batch_tests
end
