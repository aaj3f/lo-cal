class EventsController < ApplicationController
  
  get '/events' do
    if logged_in?
      @events = Event.all
      erb :'/events/index'
    else
      redirect :'/'
    end
  end


end
