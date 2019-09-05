class Api::V1::AttendanceController < Api::ApiController

  def attendance
    @attendance_logs = AttendanceLog.where(roll_number: params[:roll_number]).order(:log_date)
    @attendance_logs_by_month = @attendance_logs.group_by{|log| log.log_date.month}
    render json: { status: 'success', attendance_logs: @attendance_logs, attendance_logs_by_month: @attendance_logs_by_month }
  end

end
