class ExtractZIPCSVError < StandardError; end

module Admin
  module DataImport
    class ExtractZipCsvService
      require 'csv'
      attr_reader :file_name

      def initialize(file_name)
        @file_name = file_name
      end

      def call
        validate_request
         # new zip file path
        zip_name = "zip_#{Time.now.to_i}"
        zip_file_path = "#{Rails.root}/zip_data/#{zip_name}.zip"
        # remove old data zip and csv files
        FileUtils.rm_rf(Dir.glob("#{Rails.root}/zip_data/*.csv"))
        FileUtils.rm_rf(Dir.glob("#{Rails.root}/zip_data/*.zip"))

        FileUtils.mv file_name, zip_file_path

        Zip::ZipFile.open(zip_file_path) { |zip_file|
          zip_file.each { |f|
            f_path=File.join("#{Rails.root}/zip_data/", f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(f, f_path) {true}
          }
        }
        return {status: true, message: 'File extracted successfully'}
      rescue ExtractZIPCSVError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise ExtractZIPCSVError, 'File not found, file must be present' if file_name.blank?
      end

    end
  end
end
