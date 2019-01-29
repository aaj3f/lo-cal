class RsvpsController < ApplicationController

  post '/rsvps' do
    binding.pry
    event = Event.find_by_id(params[:event])
    response = params[:rsvp]
    user = User.find_by_id(session[:user_id])
    if event && user && response && !(user.events.include?(event))
      rsvp = Rsvp.create(user_id: user.id, event_id: event.id, status: response)
      redirect :"/events/#{event.id}"
    else
      redirect :"/events"
    end
  end

  patch '/rsvps/:id' do
    event = Event.find_by_id(params[:id])
    new_response = params[:rsvp]
    user = User.find_by_id(session[:user_id])
    if event && user && new_response && user.events.include?(event)
      Rsvp.find_by(user_id: user.id, event_id: event.id).update(status: new_response)
      redirect :"/events/#{event.id}"
    else
      redirect :"/events"
    end
  end

end


##Can be refactored so that we don't have to initialize `user` but just use current_user & logged_in? helpers
