class Api::V1::ResultController < Api::ApiController

  def list_of_test
    @student = Student.find_by(student_id: params[:student_id])
    all_tests_for_batches = all_tests_for_student_batches
    sorted_all_tests_for_batches = all_tests_for_batches.sort_by {|test_id, test| test.test_date}
    sorted_all_tests_for_batches.reverse!
    last_10_test = sorted_all_tests_for_batches.first(10)
    
     @tests = last_10_test.map { |test_id, test|
      {
        test_id: test_id,
        test_name: test.name,
        description: test.description,
        test_date: test.test_date,
        test_time: '10:00 AM',
        toppers: test.get_toppers(50, test_id)
      }
    } 
    @tests.present? ? (render status: :ok) : (render status: :bad_request)
  end

  def all_tests_for_student_batches
    student_batches = @student.batches unless @student.nil?
    all_tests_for_batches = student_batches.map{ |student_batch| 
      all_tests_for_batch = student_batch.tests.order('test_date DESC').index_by(&:id)
    }.reduce(:merge)
  end

  def download_questions
    test_id = params[:test_id]
    file_name = "#{test_id}_question_paper.pdf"

    # CLIENT_NAME_HERE
    file_path = "#{Rails.root}/papers/#{file_name}"
    pdf = open(file_path)
    send_file file_path, :type => "application/pdf"
  end

  def download_answers
    test_id = params[:test_id]
    file_name = "#{test_id}_model_answer.pdf"

    # CLIENT_NAME_HERE
    file_path = "#{Rails.root}/papers/#{file_name}"
    pdf = open(file_path)
    send_file file_path, :type => "application/pdf"
  end

end
