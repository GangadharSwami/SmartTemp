class ImportAttLogsVError < StandardError; end

module Admin
  module DataImport
    class ImportAttLogsService
      attr_reader :file_path
      FILE_NAME = 'AttLogs.csv'

      def initialize
        @file_path = "#{get_base_file_path}/#{FILE_NAME}"
      end

      def call
        validate_request
        csv_file = File.open(file_path, "r:ISO-8859-1")
        csv = CSV.parse(csv_file, :headers => true)

        create_att_logs_params, noisy_data, id = [], [], 1

        csv.each do |csv_row|
          roll_number = csv_row['EnrollNo'].to_s.strip.to_i

          tmp_log_date = csv_row['Date'].to_s.strip
          tmp_year = tmp_log_date[0,4]
          tmp_month = tmp_log_date[4,2]
          tmp_day = tmp_log_date[6,2]
          log_date = "#{tmp_day}/#{tmp_month}/#{tmp_year}".to_date

          log_time = csv_row['Time'].to_s.strip.to_i

          row_array = "(#{id}, #{roll_number}, '#{log_date}', #{log_time},'#{Time.now}', '#{Time.now}')"
          id += 1
          if csv_row['EnrollNo'].blank? or csv_row['Date'].blank? or csv_row['Time'].blank?
            noisy_data.push row_array
          else
            create_att_logs_params.push row_array
          end
        end

        if create_att_logs_params.present?
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE attendance_logs RESTART IDENTITY")
          create_att_logs_params.each_slice(1000) do |create_att_logs_params_set|
            sql = "INSERT INTO attendance_logs (id, roll_number, log_date, log_time, created_at, updated_at) VALUES #{create_att_logs_params_set.join(", ")}"
            ActiveRecord::Base.connection.execute sql
          end
        end

        # remove duplicate entries
        #AttendanceLog.dedupe
        
        return {status: true, message: 'Attendance Logs imported successfully'}
      rescue ImportAttLogsVError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise ImportAttLogsVError, 'File must be present' if file_path.blank?
      end

      def get_base_file_path
        "#{Rails.root}/zip_data"
      end

    end
  end
end