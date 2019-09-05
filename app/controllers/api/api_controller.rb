class Api::ApiController < ApplicationController
  #before_action :authenticate
  #before_action :set_default_response_format
  
  def authenticate
    puts "-----------------------------------------authenticating request :"
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    @current_subdomain = request.subdomain
    
    authenticate_with_http_token do |token, _options|
      @current_student = Student.find_by(api_key: token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { status: 'failure', message:"Authorization failed" }, status: :bad_request
  end

  def set_default_response_format
    request.format = :json
  end

end
