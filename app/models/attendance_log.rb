# == Schema Information
#
# Table name: attendance_logs
#
#  id          :integer          not null, primary key
#  roll_number :integer          not null
#  log_date    :date             not null
#  log_time    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


class AttendanceLog < ApplicationRecord
  validates_uniqueness_of :roll_number, :scope => [:log_date, :log_time]

end
