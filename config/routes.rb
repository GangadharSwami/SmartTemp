class SubdomainConstraint   
  
  def self.matches?(request)
     request.subdomain.present? && request.subdomain != 'www'   
  end 
end

Rails.application.routes.draw do

  # constraints SubdomainConstraint do
  #   namespace :api do
  #     namespace :v1 do
  #       get 'sign-in' => 'login#sign_in'
  #       get 'attendance' => 'attendance#attendance'
  #       get 'toppers' => 'result#list_of_test'
  #       get 'past_exams' => 'exam#list_of_past_exams'
  #       get 'upcoming_exams' => 'exam#list_of_upcoming_exams'
  #       get 'list_of_test' => 'result#list_of_test'
  #     end
  #   end
    
  #   devise_for :clients, controllers: {
  #     sessions: 'clients/sessions'
  #   }

  #   namespace :admin do
  #     resources :home
  #     get 'import_data_home' => 'data_import#show_import', as: 'show_import'
  #     resources :test, only:[:index]
  #     post 'upload_test_data' => 'test#upload_test_data'
  #     get 'remove/:paper/:test_id' => 'test#delete_papers'
  #     post 'file_upload_db_zip' => 'data_import#file_upload_db_zip'
  #   end
  #   root to: 'admin/home#index'
  # end
    namespace :api do
      namespace :v1 do
        post 'sign-in' => 'login#sign_in'
        get 'attendance' => 'attendance#attendance'
        get 'toppers' => 'result#list_of_test'
        get 'past_exams' => 'exam#list_of_past_exams'
        get 'upcoming_exams' => 'exam#list_of_upcoming_exams'
        get 'list_of_test' => 'result#list_of_test'
        get 'list_of_events' => 'event#list_of_events'
        post 'create_feedback' => 'feedback#create_feedback'
        post 'add_notification_token' => 'notification#add_notification_token'
        post 'send_push_notifications' => 'notification#send_push_notifications'
        get 'list_student_notifications' => 'notification#list_student_notifications'
        get 'download_questions' => 'result#download_questions'
        get 'download_answers' => 'result#download_answers'
        get 'get_gallery' => 'feedback#get_gallery'
      end
    end
    
    devise_for :clients, controllers: {
      sessions: 'clients/sessions'
    }

    namespace :admin do
      resources :home
      get 'import_data_home' => 'data_import#show_import', as: 'show_import'
      resources :test, only:[:index]
      post 'upload_test_data' => 'test#upload_test_data'
      get 'remove/:paper/:test_id' => 'test#delete_papers'
      post 'file_upload_db_zip' => 'data_import#file_upload_db_zip'
      post 'attendance_upload_db_zip' => 'data_import#upload_attendance_data'
    end
    root to: 'admin/home#index'
  
    
end