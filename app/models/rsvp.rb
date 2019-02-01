class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  def print_status
    case self.status
    when "accept"
      "\"I'm going!\""
    when "interested"
      "\"I'm interested.\""
    when "decline"
      "\"I won't be attending.\""
    end
  end

  def badge
    case self.status
    when "accept"
      "<span class=\"badge badge-pill badge-success\">You're Going!</span>"
    when "interested"
      "<span class=\"badge badge-pill badge-warning\">You're Interested</span>"
    when "decline"
      "<span class=\"badge badge-pill badge-danger\">You Declined</span>"
    end
  end
end
