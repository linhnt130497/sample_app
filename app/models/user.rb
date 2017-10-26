class User < ApplicationRecord
  before_save {self.email.downcase!}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: Settings.user.max_length_name}
  validates :password, presence: true, length: {minimum: Settings.user.min_length_password}
  validates :email, presence: true, length: {maximum: Settings.user.max_length_email},
  	format: {with: VALID_EMAIL_REGEX},
  	uniqueness: {case_sensitive: false}
  has_secure_password
end 
