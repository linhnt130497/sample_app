class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save {self.email.downcase!}
  before_create :create_activation_digest
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: Settings.user.max_length_name}
  validates :password, presence: true, length: {minimum: Settings.user.min_length_password}
  validates :email, presence: true, length: {maximum: Settings.user.max_length_email},
  format: {with: VALID_EMAIL_REGEX},
  uniqueness: {case_sensitive: false}
  has_secure_password
  scope :select_name_email, ->{select :id,:name, :email}
  scope :order_by_date, ->{order created_at: :asc}

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost) 
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest activation_token
  end
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end  

  def remember
    self.remember_token = User.new_token
    update_attributes :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def current_user? user
    user == self
  end

  def activate
    self.update_attributes activated: true, activated_at: Time.zone.now
  end
  
  private

  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest activation_token
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  private

  def downcase_email
    self.email = email.downcase
  end
end 
