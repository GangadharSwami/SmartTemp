class AddNotificationTokenError < StandardError; end

module Api
  module Notification
    class AddNotificationTokenService
      attr_reader :student_id, :student, :token

      def initialize(params)
        @student_id = params[:student_id]
        @student = Student.find_by(id: params[:student_id])
        @token = params[:token]
      end

      def call
        validate_request
        @student.notification_token = @token
        @student.save

        return {status: true, message: "Notification token updated successfully."}
      rescue AddNotificationTokenError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise AddNotificationTokenError, 'Student not found' if @student.nil?
        raise AddNotificationTokenError, 'Token not found' unless @token.present?
      end
    end
  end
end
