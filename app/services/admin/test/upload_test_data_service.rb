class UploadTestDataError < StandardError; end

module Admin
  module Test
    class UploadTestDataService
      attr_reader :test, :test_id, :question_paper, :model_answer, :subdomain

      def initialize(params, subdomain)
        @test_id = params[:test_id]
        @question_paper = params[:question_paper]
        @model_answer = params[:model_answer]
        @test = ::Test.find_by(id: params[:test_id])
        @subdomain = subdomain
   
      end

      def call
        validate_request

        @directory = check_directory
        if question_paper.present?
          upload_question_paper(question_paper.tempfile)
        end
        if model_answer.present?
          upload_model_answer(model_answer.tempfile)
        end
        
        return {status: true, message: 'Files uploaded successfully.'}
      rescue UploadTestDataError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise UploadTestDataError, 'Test not found' if test.nil?
        raise UploadTestDataError, 'Subdomain not found' if subdomain.nil?
      end

      def check_directory
        unless File.directory?("/var/app")
          FileUtils.mkdir_p("/var/app")
        end
        "/var/app"
      end

      def upload_question_paper(question_paper)
        pdf_file_name = "#{@test_id}_question_paper.pdf"
        path = File.join(@directory, pdf_file_name)
        File.open(path, "wb") { |f| f.write(question_paper.read) }
        @test.question_paper_link = pdf_file_name
        @test.save
      end

      def upload_model_answer(model_answer)
        pdf_file_name = "#{@test_id}_model_answer.pdf"
        path = File.join(@directory, pdf_file_name)
        File.open(path, "wb") { |f| f.write(model_answer.read) }
        @test.answer_paper_link = pdf_file_name
        @test.save
      
      end

    end
  end
end
