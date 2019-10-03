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
    @grand_total_days, @grand_present_days = 0, 0
    @attendance_logs = AttendanceLog.where(roll_number: 61630).order(log_date: :desc)
    @attendance_logs_by_year = @attendance_logs.group_by{|log| log.log_date.year}
    @attendance_logs_by_year_month = []
    @attendance_logs_by_year.each do |key, arr|
      year = key
      year_data = {}
      month_data = []
      month_wise =  arr.group_by{|log| log.log_date.strftime("%m")} unless arr.nil?
      month_wise.each do |key, m_data|
        d = {}
        total_days = Time.days_in_month(m_data.first.log_date.month, m_data.first.log_date.year)
        present_days = m_data.uniq {|obj| obj.log_date}.count
        first_day = "#{year}-#{key}-01"
        last_day = Date.new(year,key.to_i,-1)
        all_dates_in_month_arr = (first_day.to_date..last_day).map{ |date| date.strftime("%Y-%m-%d") }

        d[Date::ABBR_MONTHNAMES[key.to_i]] = {
          first_date: "#{year}-#{key}-01",
          total_days: total_days,
          present_days: present_days,
          absent_days: total_days - present_days,
          off_days: 0,
          present_dates: m_data,
          all_dates_arr: all_dates_in_month_arr 
        }
        month_data.push d
        @grand_total_days += total_days
        @grand_present_days += present_days 
      end
      year_data[key] = month_data
      @attendance_logs_by_year_month.push year_data
    end
   
    @attendance_head_data = {
      total_days: @grand_total_days,
      present_days: @grand_present_days,
      absent_days: @grand_total_days - @grand_present_days,
      attendance_perc: ((@grand_present_days.to_f / @grand_total_days.to_f) * 100).round(2)
    }

    
    render json: { status: 'success', attendance: @attendance_logs_by_year_month, attendance_head_data: @attendance_head_data }
  end

end
