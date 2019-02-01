class EventsController < ApplicationController

  get '/events' do
    if logged_in?
      @events_by_date = Event.index_by_date
      erb :'/events/index'
    else
      redirect :'/'
    end
  end

  get '/events/:id' do
    @event = Event.find_by_id(params[:id])
    if @event && logged_in?
      erb :"/events/show"
    elsif logged_in?
      @no_event = true
      erb :"/events/show"
    else
      redirect :"/"
    end
  end

end
