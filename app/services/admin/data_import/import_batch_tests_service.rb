class ImportBatchTestsError < StandardError; end

module Admin
  module DataImport
    class ImportBatchTestsService
      attr_reader :file_path
      FILE_NAME = 'Batch_Test_Detail.csv'

      def initialize(base_path)
        @file_path = "#{base_path}/#{FILE_NAME}"
      end

      def call
        validate_request
        csv_file = File.open(file_path, "r:ISO-8859-1")
        csv = CSV.parse(csv_file, :headers => true)

        create_batch_tests_params, noisy_data = [], []
        csv.each do |csv_row|
          formatted_csv_row = {
            id: csv_row['Batch_Test_ID'].to_s.strip,
            batch_id: csv_row['Batch_ID'].to_s.strip,
            test_id: csv_row['Test_ID'].to_s.strip
          }

          if csv_row['Batch_ID'].blank? || csv_row['Test_ID'].blank?
            noisy_data << formatted_csv_row
          else
            create_batch_tests_params << formatted_csv_row
          end
        end

        if create_batch_tests_params.present?
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE batch_tests RESTART IDENTITY")
          BatchTest.create(create_batch_tests_params)
        end
        
        return {status: true, message: 'Batch tsets imported successfully'}
      rescue ImportBatchTestsError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise ImportBatchTestsError, 'File must be present' if file_path.blank?
      end

    end
  end
end