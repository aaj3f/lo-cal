class Event < ActiveRecord::Base
  has_many :rsvps
  has_many :users, through: :rsvps

  def display_rsvps(current_user)
    unless self.rsvps.size < 2
      current_user.events.include?(self) ? user_example = "You" : user_example = self.rsvps.sample.user.first_name
      "<li>#{user_example} & #{self.rsvps.size - 1} #{self.rsvps.size > 2 ? "others" : "other user"} have RSVP'd!</li>"
    end
  end

  def display_date_and_time
    if self.date_and_time.strftime("%H:%M:%S") == "00:00:00"
      "#{self.date_and_time.strftime("%A, %B %e")}"
    else
      "#{self.date_and_time.strftime("%A, %B %e &#8212 %I:%M%p")}"
    end
  end

  def display_organizer
    "<li>Organized by #{self.organizer}</li>" if self.organizer != self.location
  end

  def self.index_by_date
    self.all.group_by {|event| event.date_and_time.strftime("%y-%m-%d")}.sort.to_h.delete_if do |date_key, value|
      Date.parse(date_key) < Date.today
    end
  end

  def find_rsvp_by_user(current_user)
    Rsvp.find_by(user_id: current_user.id, event_id: self.id)
  end

end
