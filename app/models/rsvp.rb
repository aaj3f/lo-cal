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
end
