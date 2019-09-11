class Api::V1::FeedbackController < Api::ApiController

  def create_feedback
    @response = Api::Feedback::CreateFeedbackService.new(params).call
    @response[:status] ? (render status: :ok) : (render status: :bad_request)
  end

  def get_gallery
    @images = []
    (1..17).each do |index|
      @images << { image: "https://#{request.host}#{ActionController::Base.helpers.asset_path("#{index}.jpg")}" }
    end

    (1..15).each do |i|
      index = "0#{i}"
      @images << { image: "https://#{request.host}#{ActionController::Base.helpers.asset_path("#{index}.jpg")}" }
    end
    
  end
end
