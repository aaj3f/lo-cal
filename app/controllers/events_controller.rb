class EventsController < ApplicationController

  # -- READ (#Index) --
  get '/events' do
    if logged_in?
      @events_by_date = Event.index_by_date
      erb :'/events/index'
    else
      flash[:error] = "Please first log in or sign up to begin!"
      redirect :'/'
    end
  end

  # -- READ (#Show) -- 
  get '/events/:id' do
    @event = Event.find_by_id(params[:id])
    if @event && logged_in?
      erb :"/events/show"
    elsif logged_in?
      flash[:error] = "No such event exists."
      redirect :'/'
    else
      flash[:error] = "Please first log in or sign up to begin!"
      redirect :"/"
    end
  end

end
