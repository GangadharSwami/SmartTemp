class Admin::DataImportController < Admin::BaseController
  require 'csv'
  
  def show_import
  end

  def upload_attendance_data
    temp_file = params["att_zip"].tempfile rescue nil
    Admin::DataImport::ExtractZipCsvService.new(temp_file).call
    Admin::DataImport::ImportAttLogsService.new.call
  end

  def file_upload_db_zip
    temp_file = params["file"].tempfile rescue nil
    Admin::DataImport::ExtractZipCsvService.new(temp_file).call
    Admin::DataImport::ImportDataService.new.call
  end

end
