class Api::V1::LoginController < Api::ApiController
  #skip_before_action :authenticate, only: [:sign_in]

  def sign_in
    @student = Student.where(parent_mobile_number: params[:parentMobile], roll_number: params[:rollNumber])
    @student.present? ? (render status: :ok) : (render status: :bad_request)
  end
  
end
