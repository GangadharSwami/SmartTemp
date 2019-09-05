class ImportStudentsError < StandardError; end

module Admin
  module DataImport
    class ImportStudentsService
      attr_reader :file_path
      FILE_NAME = 'Student_Master.csv'

      def initialize(base_path)
        @file_path = "#{base_path}/#{FILE_NAME}"
      end

      def call
        validate_request
        csv_file = File.open(file_path, "r:ISO-8859-1")
        csv = CSV.parse(csv_file, :headers => true)

        create_students_params, noisy_data = [], []

        csv.each do |csv_row|
          id = csv_row['Student_ID'].to_s.strip.to_i
          student_id = csv_row['Student_ID'].to_s.strip.to_i
          student_roll_no = csv_row['Student_Roll_No'].to_s.strip.to_i
          name = (("#{csv_row['FName'].to_s.strip} #{csv_row['MName'].to_s.strip} #{csv_row['LName'].to_s.strip}").presence || '-')
          mothers_name = (csv_row['MotherName'].to_s.strip.presence || '-')
          dob = (Date.parse(csv_row['DOB'].to_s.strip) rescue Time.now )
          gender = (csv_row['Gender'].to_s.strip.downcase == 'female' ? 1 : 0)
          marks_10 = csv_row['Marks10'].to_s.strip.to_i
          contact = (csv_row['Contact'].to_s.strip.presence || '-')
          parent_contact = (csv_row['Parent_Contact'].to_s.strip.presence || '-')
          db_time = Time.now
          api_key = Student.genareate_api_key

          row_array = "(#{id}, #{student_id}, #{student_roll_no}, '#{name}', '#{mothers_name}', '#{dob}', #{gender}, #{marks_10}, '#{contact}', '#{parent_contact}', '#{api_key}','#{db_time}', '#{db_time}' )"
          if csv_row['Parent_Contact'].blank?
            noisy_data.push row_array
          else
            create_students_params.push row_array
          end
        end

        if create_students_params.present?
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE students RESTART IDENTITY")
          create_students_params.each_slice(1000) do |create_students_params_set|
            sql = "INSERT INTO students (id, student_id, roll_number, name, mother_name, date_of_birth, gender, tenth_marks, contact, parent_mobile_number, api_key, created_at, updated_at) VALUES #{create_students_params_set.join(", ")}"
            ActiveRecord::Base.connection.execute sql
          end
        end
        
        return {status: true, message: 'Students imported successfully'}
      rescue ImportStudentsError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise ImportStudentsError, 'File must be present' if file_path.blank?
      end

    end
  end
end