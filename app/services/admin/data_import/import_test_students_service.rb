class ImportTestStudentsError < StandardError; end

module Admin
  module DataImport
    class ImportTestStudentsService
      attr_reader :file_path
      FILE_NAME = 'Test_Detail.csv'

      def initialize(base_path)
        @file_path = "#{base_path}/#{FILE_NAME}"
      end

      def call
        validate_request
       
        csv_file = File.open(file_path, "r:ISO-8859-1")
        csv = CSV.parse(csv_file, :headers => true)

        create_test_students_params, noisy_data = [], []

        csv.each do |csv_row|
          row_array = "(#{csv_row['Test_ID'].to_s.strip}, #{csv_row['Student_ID'].to_s.strip}, #{csv_row['Student_Marks'].to_s.strip}, '#{csv_row['Student_ans_key'].to_s.strip}', #{csv_row['Rank'].to_s.strip}, '#{Time.now}', '#{Time.now}')"
          if csv_row['Test_ID'].blank? || csv_row['Student_ID'].blank?
            noisy_data.push row_array
          else
            create_test_students_params.push row_array
          end

        end

        ## comment added to check deployements
        if create_test_students_params.present?
          # columns = [:test_id, :student_id, :student_marks, :student_answer_key, :rank]
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE test_students RESTART IDENTITY")
          create_test_students_params.each_slice(10000) do |create_test_students_params_set|
            sql = "INSERT INTO test_students (test_id, student_id, student_marks, student_answer_key, rank, created_at, updated_at) VALUES #{create_test_students_params_set.join(", ")}"
            ActiveRecord::Base.connection.execute sql
          end
        end

        return {status: true, message: 'Tset students imported successfully'}
      rescue ImportTestStudentsError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise ImportTestStudentsError, 'File must be present' if file_path.blank?
      end

    end
  end
end