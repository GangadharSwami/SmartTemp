class ImportBatchesError < StandardError; end

module Admin
  module DataImport
    class ImportBatchesService
      attr_reader :file_path
      FILE_NAME = 'Batch_Master.csv'

      def initialize(base_path)
        @file_path = "#{base_path}/#{FILE_NAME}"
      end

      def call
        validate_request
        csv_file = File.open(file_path, "r:ISO-8859-1")
        csv = CSV.parse(csv_file, :headers => true)

        create_batches_params, noisy_data = [], []
        csv.each do |csv_row|
          formatted_csv_row = {
            id: csv_row['Batch_ID'].to_s.strip,
            name: csv_row['Batch_Name'].to_s.strip
          }

          if csv_row['Batch_ID'].blank? || csv_row['Batch_Name'].blank?
            noisy_data << formatted_csv_row
          else
            create_batches_params << formatted_csv_row
          end
        end

        if create_batches_params.present?
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE batches RESTART IDENTITY")
          Batch.create(create_batches_params)
        end
        
        return {status: true, message: 'Batches imported successfully'}
      rescue ImportBatchesError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise ImportBatchesError, 'File must be present' if file_path.blank?
      end

    end
  end
end