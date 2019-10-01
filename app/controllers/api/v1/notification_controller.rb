class Api::V1::NotificationController < Api::ApiController

  def add_notification_token
    @response = Api::Notification::AddNotificationTokenService.new(params).call
    @response[:status] ? (render status: :ok) : (render status: :bad_request) 
  end

  def send_push_notifications
    @response = Api::Notification::SendPushNotificationService.new(params).call
    @response[:status] ? (render status: :ok) : (render status: :bad_request) 
  end

   def list_student_notifications
    @notifications = Student.find_by(id: params[:student_id]).notifications.order(created_at: :desc)
  end
end
