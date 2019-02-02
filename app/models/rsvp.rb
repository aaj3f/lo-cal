class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

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
