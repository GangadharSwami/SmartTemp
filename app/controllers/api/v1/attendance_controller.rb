class Api::V1::AttendanceController < Api::ApiController

  def attendance
    # @attendance_logs = AttendanceLog.where(roll_number: params[:roll_number]).order(:log_date)
    # @attendance_logs_by_month = @attendance_logs.group_by{|log| log.log_date.month}
    # render json: { status: 'success', attendance_logs: @attendance_logs, attendance_logs_by_month: @attendance_logs_by_month }
    @attendance = [
      {
        date: Date.today,
        present: false,
        exam: true,
        holiday: false,
        absent_reason: 'family reasons',
        holiday_reason: '',
        exam_name: 'Chemistry MCQ exam' 
      },
      {
        date: Date.today - 1.day,
        present: true,
        exam: false,
        holiday: false,
        absent_reason: '',
        holiday_reason: '',
        exam_name: '' 
      },
      {
        date: Date.today - 3.day,
        present: true,
        exam: true,
        holiday: false,
        absent_reason: '',
        holiday_reason: '',
        exam_name: 'Physics Theory exam' 
      },
      {
        date: Date.today - 5.day,
        present: false,
        exam: true,
        holiday: false,
        absent_reason: "family reasons",
        holiday_reason: '',
        exam_name: "Chemistry MCQ exam" 
      },
      {
        date: Date.today - 8.day,
        present: true,
        exam: false,
        holiday: true,
        absent_reason: '',
        holiday_reason: 'Ram Navami',
        exam_name: '' 
      },
    ]
  end

end
