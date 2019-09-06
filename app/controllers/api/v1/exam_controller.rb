class Api::V1::ExamController < Api::ApiController

  def list_of_past_exams
    student_id = params[:student_id]
    @past_exams = Test.joins(:test_students).where("test_students.student_id = ? and tests.test_date < ?", student_id, Date.today).select("tests.*, test_students.*")
  end

  def list_of_upcoming_exams
    student_id = params[:student_id]
    @upcoming_exams = Test.where("tests.test_date > ?", Date.today)
  end
end
