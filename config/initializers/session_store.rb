# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_smart-class-admin_session', domain: {
  production:   '.smartclassadmin.com',
  staging:      '.smartclassadmin.com'
  
}.fetch(Rails.env.to_sym, :all)
