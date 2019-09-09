class CreateFeedbackError < StandardError; end

module Api
  module Feedback
    class CreateFeedbackService
      attr_reader :student_id, :mobile_number, :name, :feedback

      def initialize(params)
        @student_id = params[:student_id]
        @mobile_number = params[:mobile_number]
        @name = params[:name]
        @feedback = params[:feedback]
      end

      def call
        validate_request

        Feedback.create(student_id: @student_id, name: @name, mobile_number: @mobile_number, feedback: @feedback)
        
        return {status: true, message: "Feedback added successfully."}
      rescue CreateFeedbackError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise CreateFeedbackError, 'Student not found' if student_id.nil?
        raise CreateFeedbackError, 'Mobile number not found' if mobile_number.nil?
        raise CreateFeedbackError, 'Name not found' if name.nil?
        raise CreateFeedbackError, 'Feedback not found' if feedback.nil?
      end
    end
  end
end
