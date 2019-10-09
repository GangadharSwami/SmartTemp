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

        if question_paper.present?
          @test.update!(question_paper_link: @question_paper)
        end
        if model_answer.present?
          @test.update!(answer_paper_link: @model_answer)
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

    end
  end
end
