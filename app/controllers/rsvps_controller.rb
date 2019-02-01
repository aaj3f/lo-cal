class RsvpsController < ApplicationController

  post '/rsvps' do
    event = Event.find_by_id(params[:event])
    response = params[:rsvp]
    user = User.find_by_id(session[:user_id])
    if event && user && response && !(user.events.include?(event))
      rsvp = Rsvp.create(user_id: user.id, event_id: event.id, status: response)
      flash[:notice] = 'We\'ve RSVP\'d you for this event!'
      redirect :"/events/#{event.id}"
    else
      redirect :"/events"
    end
  end

  patch '/rsvps/:id' do
    event = Event.find_by_id(params[:id])
    new_response = params[:rsvp]
    if event && logged_in? && new_response && current_user.events.include?(event)
      Rsvp.find_by(user_id: current_user.id, event_id: event.id).update(status: new_response)
      flash[:notice] = 'We\'ve updated your RSVP!'
      redirect :"/events/#{event.id}"
    else
      redirect :"/events"
    end
  end

  delete '/rsvps/:id' do
    event = Event.find_by_id(params[:id])
    if event && logged_in? && current_user.events.include?(event)
      Rsvp.find_by(user_id: current_user.id, event_id: event.id).destroy
      flash[:error] = "We've deleted your RSVP for #{event.name}"
      redirect :"/events"
    else
      redirect :"/events"
    end
  end

end


##Can be refactored so that we don't have to initialize `user` but just use current_user & logged_in? helpers
