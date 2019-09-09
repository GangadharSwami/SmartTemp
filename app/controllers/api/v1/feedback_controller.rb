class Api::V1::FeedbackController < Api::ApiController

  def create_feedback
    @response = Api::Feedback::CreateFeedbackService.new(params).call
    @response[:status] ? (render status: :ok) : (render status: :bad_request)
  end
end
