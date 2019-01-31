class EventsController < ApplicationController

  get '/events' do
    if logged_in?
      @events = Event.all
      @events_by_date = Event.all.group_by {|event| event.date_and_time.strftime("%y-%m-%d")}.sort.to_h
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
