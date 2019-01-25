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

  post '/signup' do
    @user = User.new(params[:user])
    if already_a_user?(@user)
      erb :signup

      ##ned to process a correct submission


  end

end
