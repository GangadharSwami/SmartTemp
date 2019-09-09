class SendPushNotificationError < StandardError; end

module Api
  module Notification
    class SendPushNotificationService
      attr_reader :title, :description

      def initialize(params)
        @title = params[:title]
        @description = params[:description]
      end

      def call
        validate_request
        exponent = Exponent::Push::Client.new
        create_notification
        messages = Student.with_notification_token.map do |student|
          create_student_notification(student)
          {
            to: student.notification_token,
            sound: "default",
            title: @title,
            body: @description,
            data: {
              title: @title,
              body: @body
            }
          }
        end
        @res = exponent.publish messages
        
        return {status: true, message: "Notifications send successfully."}
      rescue SendPushNotificationError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def validate_request
        raise SendPushNotificationError, 'Title not found' unless @title.present?
        raise SendPushNotificationError, 'Description not found' unless @description.present?
      end

      def create_notification
        @notification = ::Notification.create(title: @title, description: @description)
      end

      def create_student_notification(student)
        StudentNotification.create(student_id: student.id, notification_id: @notification.id)
      end
    end
  end
end
