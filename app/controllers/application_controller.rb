class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :sessions, true
    set :session_secret, ENV.fetch("SESSION_SECRET")
  end

  use Rack::Flash

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
      @user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def simplify_date(date)
      date_object = DateTime.parse(date)
      if date_object == Date.today
        "Today"
      elsif date_object == Date.tomorrow
        "Tomorrow"
      else
        date_object.strftime("%A &#8212; %b %e")
      end
    end

  end

end
