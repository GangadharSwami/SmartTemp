class Api::V1::AttendanceController < Api::ApiController

  # def attendance
  #   # @attendance_logs = AttendanceLog.where(roll_number: params[:roll_number]).order(:log_date)
  #   # @attendance_logs_by_month = @attendance_logs.group_by{|log| log.log_date.month}
  #   # render json: { status: 'success', attendance_logs: @attendance_logs, attendance_logs_by_month: @attendance_logs_by_month }
  #   @attendance = [
  #     {
  #       date: Date.today,
  #       present: false,
  #       exam: true,
  #       holiday: false,
  #       absent_reason: 'family reasons',
  #       holiday_reason: '',
  #       exam_name: 'Chemistry MCQ exam' 
  #     },
  #     {
  #       date: Date.today - 1.day,
  #       present: true,
  #       exam: false,
  #       holiday: false,
  #       absent_reason: '',
  #       holiday_reason: '',
  #       exam_name: '' 
  #     },
  #     {
  #       date: Date.today - 3.day,
  #       present: true,
  #       exam: true,
  #       holiday: false,
  #       absent_reason: '',
  #       holiday_reason: '',
  #       exam_name: 'Physics Theory exam' 
  #     },
  #     {
  #       date: Date.today - 5.day,
  #       present: false,
  #       exam: true,
  #       holiday: false,
  #       absent_reason: "family reasons",
  #       holiday_reason: '',
  #       exam_name: "Chemistry MCQ exam" 
  #     },
  #     {
  #       date: Date.today - 8.day,
  #       present: true,
  #       exam: false,
  #       holiday: true,
  #       absent_reason: '',
  #       holiday_reason: 'Ram Navami',
  #       exam_name: '' 
  #     },
  #   ]
  # end
  def attendance
    @attendance_logs = AttendanceLog.where(roll_number: params[:roll_number]).order(log_date: :desc)
    @attendance_logs_by_year = @attendance_logs.group_by{|log| log.log_date.year}
    @attendance_logs_by_year_month = []
    @attendance_logs_by_year.each do |key, arr|
      year_data = {}
      month_data = []
      month_wise =  arr.group_by{|log| log.log_date.strftime("%b")} unless arr.nil?
      month_wise.each do |key, m_data|
        d = {}
        total_days = Time.days_in_month(m_data.first.log_date.month, m_data.first.log_date.year)
        present_days = m_data.uniq {|obj| obj.log_date}.count

        d[key] = {
          total_days: total_days,
          present_days: present_days,
          all_dates: m_data 
        }
        month_data.push d
      end
      year_data[key] = month_data
      @attendance_logs_by_year_month.push year_data
    end
    
    render json: { status: 'success', attendance: @attendance_logs_by_year_month }
  end

end
