class UsersController < ApplicationController
  get '/users/:id' do
    @user = User.find_by_id(params[:id])
    if @user && @user.id == session[:user_id]
      @user_events_by_date = current_user.events.group_by {|event| event.date_and_time.strftime("%y-%m-%d")}.sort.to_h
      erb :'/users/show'
    else
      redirect :'/'
    end
  end
end
