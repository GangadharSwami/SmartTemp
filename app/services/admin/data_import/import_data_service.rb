class ImportDataError < StandardError; end

module Admin
  module DataImport
    class ImportDataService
      
      def initialize
      end

      def call
        validate_request

        import_students
        import_batch
        import_test

        import_batch_students
        import_batch_tests
        import_test_students
        
        return {
          status: true,
          message: 'Data Imported Successfully. :)',
          'Total students Created' => Student.count,
          'Total batches Created' => Batch.count,
          'Total tests Created' => Test.count,

          'Batch updated for Students (BatchStudent) ' => BatchStudent.count,
          'Tests updated for Batches (BatchTest) ' => BatchTest.count,
          'Students updated for Tests (TestStudent) ' => TestStudent.count
        }
      rescue ImportDataError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        #raise ImportDataError, 'File must be present' if file_path.blank?
      end

      def import_students
        Admin::DataImport::ImportStudentsService.new(get_base_file_path).call
      end

      def import_batch
        Admin::DataImport::ImportBatchesService.new(get_base_file_path).call
      end

      def import_test
        Admin::DataImport::ImportTestsService.new(get_base_file_path).call
      end

      def import_batch_students
        Admin::DataImport::ImportBatchStudentsService.new(get_base_file_path).call
      end

      def import_batch_tests
        Admin::DataImport::ImportBatchTestsService.new(get_base_file_path).call
      end

      def import_test_students
        Admin::DataImport::ImportTestStudentsService.new(get_base_file_path).call 
      end

      def get_base_file_path
        "#{Rails.root}/zip_data"
      end

    end
  end
end