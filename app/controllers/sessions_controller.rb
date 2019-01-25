class SessionsController < ApplicationController

  get '/login' do
    if logged_in?
      redirect :"/events"
    else
      erb :login
    end
  end

  get '/signup' do
    if logged_in?
      redirect :'/events'
    else
      erb :signup
    end
  end

end
