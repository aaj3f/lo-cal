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
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect :"/users/#{@user.id}"
    elsif @user && !(@user.authenticate(params[:user][:password]))
      @user.errors.add(:password, "does not match our records.")
      erb :login
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
    binding.pry
    @user = User.new(params[:user])
    if @user.already_a_user? || !(@user.save)
      erb :signup
    else
      session[:user_id] = @user.id
      redirect :"/users/#{@user.id}"
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect :'/'
    else
      redirect :'/'
    end
  end

end
