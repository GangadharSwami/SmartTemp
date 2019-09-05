class ImportTestsError < StandardError; end

module Admin
  module DataImport
    class ImportTestsService
      attr_reader :file_path
      FILE_NAME = 'Test_Master.csv'

      def initialize(base_path)
        @file_path = "#{base_path}/#{FILE_NAME}"
      end

      def call
        validate_request
        csv_file = File.open(file_path, "r:ISO-8859-1")
        csv = CSV.parse(csv_file, :headers => true)

        create_tests_params, noisy_data = [], []
        csv.each do |csv_row|
          test_date = csv_row['Test_Date'].to_s.strip
          test_date = Date.new(test_date[0,4].to_i, test_date[4,2].to_i, test_date[6,2].to_i) rescue Date.today
          formatted_csv_row = {
            id: csv_row['Test_ID'].to_s.strip,
            name: csv_row['Test_Name'].to_s.strip.humanize ,
            description: csv_row['Descripation'].to_s.strip.humanize ,
            test_date: test_date,
            no_of_questions: csv_row['No_of_Questions'].to_s.strip.to_i ,
            total_marks: csv_row['No_of_Marks'].to_s.strip.to_i ,
            passing_marks: csv_row['Pass_Marks'].to_s.strip.to_i ,
            answer_key: csv_row['Answer_Key'].to_s.strip,
            is_theory: csv_row['Is_Theory'].to_s.strip == 'TRUE' ,
            is_combined: csv_row['Is_Combine'].to_s.strip == 'TRUE' ,
          }

          if csv_row['Test_ID'].blank?
            noisy_data << formatted_csv_row
          else
            create_tests_params << formatted_csv_row
          end
        end

        if create_tests_params.present?
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE tests RESTART IDENTITY")
          ::Test.create!(create_tests_params)
        end
        
        return {status: true, message: 'Tests imported successfully'}
      rescue ImportTestsError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise ImportTestsError, 'File must be present' if file_path.blank?
      end

    end
  end
end