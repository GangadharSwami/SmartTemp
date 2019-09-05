class Api::V1::ResultController < Api::ApiController

  def list_of_test
    @student = Student.find_by(student_id: params[:student_id])
    all_tests_for_batches = all_tests_for_student_batches
    sorted_all_tests_for_batches = all_tests_for_batches.sort_by {|test_id, test| test.test_date}
    sorted_all_tests_for_batches.reverse!
    last_10_test = sorted_all_tests_for_batches.first(10)
    @tests = []
    last_10_test.each do |test_id, test|
      @tests << {
        test_id: test_id,
        test_name: test.name,
        description: test.description,
        test_date: test.test_date,
        toppers: test.get_toppers(50, test_id)
      }
    end
    @tests.present? ? (render status: :ok) : (render status: :bad_request)
  end

  def all_tests_for_student_batches
    student_batches = @student.batches || []

      all_tests_for_batches = {}
      student_batches.each do |student_batch|
        all_tests_for_batch = student_batch.tests.order('test_date DESC').index_by(&:id)
        all_tests_for_batches.merge!(all_tests_for_batch)
      end
      all_tests_for_batches
  end

  def download_questions
    test_id = params[:test_id]
    file_name = "#{test_id}_question_paper.pdf"

    # CLIENT_NAME_HERE
    file_path = "/var/app/#{@current_subdoamin}/#{file_name}"
    pdf = open(file_path)
    send_file file_path, :type => "application/pdf"
  end

  def download_answers
    test_id = params[:test_id]
    file_name = "#{test_id}_model_answer.pdf"

    # CLIENT_NAME_HERE
    file_path = "/var/app/#{@current_subdoamin}/#{file_name}"
    pdf = open(file_path)
    send_file file_path, :type => "application/pdf"
  end

end
