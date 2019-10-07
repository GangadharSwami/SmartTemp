class Api::V1::ExamController < Api::ApiController

  # def list_of_past_exams
  #   @student_id = params[:student_id].to_i
  #   @past_exams = Test.joins(:test_students).where("test_students.student_id = ? and tests.test_date < ?", @student_id, Date.today).
  #     select("tests.*, test_students.*, to_char(tests.test_date, 'dd/mm/yyyy') as formatted_test_date")
  #   @past_exams.each do |exam|
  #     exam.rank = get_rank(exam.test_id)
  #   end 
  #   @past_exams = @past_exams.map{ |exam|
  #     {
  #       id: exam.id,
  #       name: exam.name,
  #       description: exam.description,
  #       test_date: exam.formatted_test_date,
  #       no_of_questions: exam.no_of_questions,
  #       total_marks: exam.total_marks,
  #       passing_marks: exam.passing_marks,
  #       answer_key: exam.answer_key,
  #       is_theory: exam.is_theory,
  #       is_combined: exam.is_combined,
  #       question_paper_link: exam.question_paper_link,
  #       answer_paper_link: exam.answer_paper_link,
  #       created_at: exam.created_at,
  #       test_id: exam.test_id,
  #       student_marks: exam.student_marks,
  #       student_answer_key: exam.student_answer_key,
  #       rank: exam.rank,
  #       test_duration: '45 min',
  #       test_time: '10.00 AM',
  #       is_student_present: true
  #     }
  #   }  
  # end

  def list_of_past_exams
    @student_id = params[:student_id].to_i
    @past_exams = Test.joins(:test_students).where("test_students.student_id = ? and tests.test_date < ?", @student_id, Date.today).order(test_date: :desc).select("tests.*, test_students.*, to_char(tests.test_date, 'dd Mon yyyy') as formatted_test_date")
    @past_exams.each do |exam|
      exam.rank = get_rank(exam.test_id)
    end
    @past_exams = @past_exams.map{ |exam|
      {
        id: exam.id,
        name: exam.name,
        description: exam.description,
        test_date: exam.formatted_test_date,
        no_of_questions: exam.no_of_questions,
        total_marks: exam.total_marks,
        passing_marks: exam.passing_marks,
        answer_key: exam.answer_key,
        is_theory: exam.is_theory,
        is_combined: exam.is_combined,
        question_paper_link: exam.question_paper_link,
        answer_paper_link: exam.answer_paper_link,
        created_at: exam.created_at,
        test_id: exam.test_id,
        student_marks: exam.student_marks,
        student_answer_key: exam.student_answer_key,
        rank: exam.rank,
        test_duration: '45 min',
        test_time: '10.00 AM',
        is_student_present: true,
        review_answers: answers_data(exam.answer_key, exam.student_answer_key)
      }
    }  
  end

  def list_of_upcoming_exams
    @student_id = params[:student_id].to_i
    student_batch = BatchStudent.find_by(student_id: @student_id)
    @upcoming_exams = Test.joins(:batch_tests).where("tests.test_date > ? and batch_tests.batch_id = ?", Date.today, student_batch.batch_id).select("tests.*, to_char(test_date, 'dd/mm/yyyy') as formatted_test_date")
    @upcoming_exams = @upcoming_exams.map{ |exam|
      {
        id: exam.id,
        name: exam.name,
        description: exam.description,
        test_date: exam.formatted_test_date,
        no_of_questions: exam.no_of_questions,
        total_marks: exam.total_marks,
        passing_marks: exam.passing_marks,
        answer_key: exam.answer_key,
        is_theory: exam.is_theory,
        is_combined: exam.is_combined,
        question_paper_link: exam.question_paper_link,
        answer_paper_link: exam.answer_paper_link,
        created_at: exam.created_at,
        test_duration: '45 min',
        test_time: '10.00 AM'
      }
    }
  end

  private

   def answers_data(answer_key, student_answer_key)
    answer_key_arr = answer_key.split('')
    student_key_arr = student_answer_key.split('')
    q_count = 0
    final_data = answer_key_arr.zip(student_key_arr).map do |modal_ans, student_ans|
      q_count += 1
      {
        question_no: q_count,
        modal_ans: modal_ans,
        student_ans: student_ans,
        marks: student_ans == "@" ? "0" : (student_ans == modal_ans ? "+4" : "-1" )
      }
    end
    final_data
  end

  def get_rank(test_id)
    tests = TestStudent.where(test_id: test_id).select('test_id, student_id, student_marks, rank() OVER (PARTITION BY test_id ORDER BY student_marks DESC) AS rank')
    test_details =  tests.find { |data| data.student_id == @student_id }
    test_details.rank
  end
end
