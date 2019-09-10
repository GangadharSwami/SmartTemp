class Api::V1::ExamController < Api::ApiController

  def list_of_past_exams
    @student_id = params[:student_id].to_i
    @past_exams = Test.joins(:test_students).where("test_students.student_id = ? and tests.test_date < ?", @student_id, Date.today).
      select("tests.*, test_students.*, to_char(tests.test_date, 'dd/mm/yyyy') as formatted_test_date")
    @past_exams.each do |exam|
      exam.rank = get_rank(exam.test_id)
    end  
  end

  def list_of_upcoming_exams
    @upcoming_exams = Test.where("tests.test_date > ?", Date.today).select("tests.*, to_char(test_date, 'dd/mm/yyyy') as formatted_test_date")
  end

  private

  def get_rank(test_id)
    tests = TestStudent.where(test_id: test_id).select('test_id, student_id, student_marks, rank() OVER (PARTITION BY test_id ORDER BY student_marks DESC) AS rank')
    test_details =  tests.find { |data| data.student_id == @student_id }
    test_details.rank
  end
end
