class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :rsvps
  has_many :events, through: :rsvps

  def already_a_user?
    flag = !!User.find_by(email: self.email)
    self.errors.add(:email, "already registered to an existing user.") if flag
    flag
  end

  def display_events_by_date
    self.events.group_by {|event| event.date_and_time.strftime("%y-%m-%d")}.sort.to_h.delete_if do |date_key, value|
      Date.parse(date_key) < Date.today
    end
  end

end
