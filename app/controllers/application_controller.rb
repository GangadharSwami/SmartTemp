class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :check_subdomain
 skip_before_action :verify_authenticity_token
  def after_sign_in_path_for(resource)
    admin_home_index_path
  end

  def check_subdomain
    if client_signed_in? && request.subdomain != current_client.subdomain
      render json: { status: 'failure', message:"Authorization failed" }, status: :bad_request
    end
  end 

  private
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :password_confirmation])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end


end
