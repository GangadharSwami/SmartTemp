# == Schema Information
#
# Table name: students
#
#  id                   :integer          not null, primary key
#  roll_number          :integer          not null
#  name                 :string           not null
#  mother_name          :string           not null
#  date_of_birth        :date
#  gender               :integer          default(0), not null
#  tenth_marks          :decimal(, )
#  contact              :string
#  parent_mobile_number :string           not null
#  deleted              :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  api_key              :string           not null
#  student_id           :integer          not null
#

class Student < ApplicationRecord
  has_many :batch_students
  has_many :batches, through: :batch_students
  has_many :test_students
  has_many :tests, through: :test_students

  before_create :set_api_key

  enum gender: {male: 0, female: 1}

  def set_api_key
    return if api_key.present?
    self.api_key = generated_api_key
  end

  def generated_api_key
    SecureRandom.uuid.gsub(/\-/,'')
  end

  def self.genareate_api_key
    SecureRandom.uuid.gsub(/\-/,'')
  end
end
