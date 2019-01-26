class UsersController < ApplicationController
  get '/users/:id' do
    @user = User.find_by_id(params[:id])
    if @user && @user.id == session[:user_id]
      @events = Event.all
      erb :'/users/show'
    else
      redirect :'/'
    end
  end
end
