class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true
  validates :password, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :rsvps
  has_many :events, through: :rsvps
end
