class Admin::TestController < Admin::BaseController
  
  def index
    @tests = ::Test.all.order(id: :desc)
  end

  def upload_test_data
    response = Admin::Test::UploadTestDataService.new(params, current_client.subdomain).call

    if(response[:status])
      flash[:success] = response[:message]
    else
      flash[:alert] = response[:message]
    end  
    redirect_to admin_test_index_path 
  end

  def delete_papers
    response = Admin::Test::DeleteTestPapersService.new(params).call

    if(response[:status])
      flash[:success] = response[:message]
    else
      flash[:alert] = response[:message]
    end  
    redirect_to admin_test_index_path 
  end

end
