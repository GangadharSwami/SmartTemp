class Api::V1::LoginController < Api::ApiController
  #skip_before_action :authenticate, only: [:sign_in]

  def sign_in
    @student = Student.find_by(parent_mobile_number: params[:parentMobile], roll_number: params[:rollNumber])
    @otp = send_otp if @student.present?
    @student.present? ? (render status: :ok) : (render status: :bad_request)
  end
  
  def send_otp
  	@mobile_number="8087780305"
  	otp = ROTP::TOTP.new("base32secret3232", issuer: "SendOtpService")
    puts "======================"
    puts otp.now
    puts "======================"
    message = "Dear User,\n  #{otp.now} is your one time password (OTP).\n Please enter this OTP to proceed.\n Thank you."
    require 'net/http'
    strUrl = "https://www.businesssms.co.in/SMS.aspx"; # Base URL
    strUrl = strUrl+"?ID=sudhakar_bhise@rediffmail1.com&Pwd=Myadmin@123&PhNo="+@mobile_number+"&Text="+message+"";
    uri = URI(strUrl)
    req = Net::HTTP.get(uri)
    otp.now
  end
end
