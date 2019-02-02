class UsersController < ApplicationController

  get '/users/:id' do
    user = User.find_by_id(params[:id])
    if user && user == current_user
      @user_events_by_date = current_user.display_events_by_date
      erb :'/users/show'
    else
      redirect :'/'
    end
  end

end
