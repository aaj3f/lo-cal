class Event < ActiveRecord::Base
  has_many :rsvps
  has_many :users, through: :rsvps

  def display_rsvps(current_user)
    if current_user.events.include?(self) && self.check_rsvp_status_by_user(current_user) == "decline"
      "<li><span class=\"badge badge-danger\">You've decided not to attend.</span></li>"
    elsif self.rsvps.size > 0
      if current_user.events.include?(self)
        user_example, badge_class = "You", "badge-success"
      else
        user_example, badge_class = self.rsvps.sample.user.first_name, "badge-info"
      end
      case self.rsvps.size
      when 0
        nil
      when 1
        "<li><span class=\"badge #{badge_class}\">#{user_example} have RSVP'd!</span></li>" if user_example == "You"
      when 2
        "<li><span class=\"badge #{badge_class}\">#{user_example} & 1 other user have RSVP'd!</span></li>"
      else
        "<li><span class=\"badge #{badge_class}\">#{user_example} & #{self.rsvps.size - 1} others have RSVP'd!</span></li>"
      end
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

  def check_rsvp_status_by_user(current_user)
    self.find_rsvp_by_user(current_user).status
  end

end
