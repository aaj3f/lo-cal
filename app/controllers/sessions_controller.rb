class SessionsController < ApplicationController

  get '/login' do
    if logged_in?
      redirect :"/events"
    else
      erb :login
    end
  end

  post '/login' do
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect :'/events'
    else
      binding.pry
      @no_user = true unless @user
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
    if @user.already_a_user? || !(@user.save)
      erb :signup
    else
      session[:user_id] = @user.id
      redirect :"/users/#{@user.id}"
    end

    ## Need to build routing for correct registration; so far only error-prone registrations are accounted for



  end

end
