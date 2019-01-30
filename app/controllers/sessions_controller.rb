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
      flash[:error] = "That password does not match our records."
      erb :login
    else
      @no_user = true unless @user
      flash[:error] = "That email address is not registered to a current user."
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
      @user.errors.full_messages.each do |error_string|
        flash[:error] = error_string
      end
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
