class SessionsController < ApplicationController

  get '/login' do
    if logged_in?
      redirect :"/users/#{@user.id}"
    else
      erb :login
    end
  end

  post '/login' do
    user = User.find_by(email: params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged in as #{user.email}!"
      redirect :"/users/#{user.id}"
    elsif user && !(user.authenticate(params[:user][:password]))
      flash[:error] = "That password does not match our records."
      redirect :"/login"
    else
      flash[:error] = "That email address is not registered to a current user."
      redirect :"/login"
    end
  end

  get '/signup' do
    if logged_in?
      redirect :"/users/#{@user.id}"
    else
      erb :signup
    end
  end

  post '/signup' do
    user = User.new(params[:user])
    if user.already_a_user? || !(user.save)
      user.errors.full_messages.each do |error_string|
        flash[:error] = error_string
      end
      redirect :"/signup"
    else
      session[:user_id] = user.id
      redirect :"/users/#{user.id}"
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
