class DeleteTestPapersError < StandardError; end

module Admin
  module Test
    class DeleteTestPapersService
      attr_reader :test, :test_id, :paper

      def initialize(params)
        @test_id = params[:test_id]
        @paper = params[:paper]
        @test = ::Test.find_by(id: params[:test_id])
        
      end

      def call
        validate_request
        if paper == 'question'
          test.question_paper_link = nil
        elsif paper == 'answer'
          test.answer_paper_link = nil
        end
        test.save  
        
        return {status: true, message: "#{paper}s  deleted successfully."}
      rescue DeleteTestPapersError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise DeleteTestPapersError, 'Test not found' if test.nil?
      end
    end
  end
end
