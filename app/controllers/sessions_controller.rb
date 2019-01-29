class SessionsController < ApplicationController

  get '/login' do
    if logged_in?
      redirect :"/users/#{current_user.id}"
    else
      erb :login
    end
  end

  post '/login' do
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect :"/users/#{@user.id}"
    else
      @no_user = true unless @user
      erb :login
    end
  end

  get '/signup' do
    if logged_in?
      redirect :"/users/#{current_user.id}"
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

  end

end
