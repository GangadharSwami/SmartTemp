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

  def self.dedupe
    # find all models and group them on keys which should be common
    ids_to_delete = []
    grouped = all.group_by{|model| [model.roll_number, model.log_date, model.log_time] }
    grouped.values.each do |duplicates|
      # the first one we want to keep right?
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each{|double| ids_to_delete << double.id} # duplicates can now be destroyed
    end
    if ids_to_delete.present?
      sql = "DELETE FROM attendance_logs WHERE id IN (#{ids_to_delete.join(',')})"
      ActiveRecord::Base.connection.execute sql
    end
  end
end
