require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :sessions, true
    set :session_secret, ENV.fetch("SESSION_SECRET")
  end

  get "/" do
    if logged_in?
      redirect :'/events'
    else
      erb :welcome
    end
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def already_a_user?(user)
      flag = !!User.find_by(email: user.email)
      errors.add(:email, "already registered to an existing user.") if flag
      flag
    end
  end

end
