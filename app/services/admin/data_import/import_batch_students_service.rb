class ImportBatchStudentsError < StandardError; end

module Admin
  module DataImport
    class ImportBatchStudentsService
      attr_reader :file_path
      FILE_NAME = 'Batch_Student.csv'

      def initialize(base_path)
        @file_path = "#{base_path}/#{FILE_NAME}"
      end

      def call
        validate_request
        csv_file = File.open(file_path, "r:ISO-8859-1")
        csv = CSV.parse(csv_file, :headers => true)

        create_batch_students_params, noisy_data = [], []
        csv.each do |csv_row|
          batch_id = csv_row['Batch_ID'].to_s.strip.to_i
          student_id = csv_row['Student_ID'].to_s.strip.to_i
          db_time = Time.now

          row_array = "(#{batch_id}, #{student_id}, '#{db_time}', '#{db_time}')"
          if csv_row['Batch_ID'].blank? || csv_row['Student_ID'].blank?
            noisy_data.push row_array
          else
            create_batch_students_params.push row_array
          end
        end

        if create_batch_students_params.present?
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE batch_students RESTART IDENTITY")
          create_batch_students_params.each_slice(1000) do |create_batch_students_params_set|
            sql = "INSERT INTO batch_students (batch_id, student_id, created_at, updated_at) VALUES #{create_batch_students_params_set.join(", ")}"
            ActiveRecord::Base.connection.execute sql
          end
        end
        
        return {status: true, message: 'Batch students imported successfully'}
      rescue ImportBatchStudentsError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise ImportBatchStudentsError, 'File must be present' if file_path.blank?
      end

    end
  end
end