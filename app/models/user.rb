class User < ApplicationRecord
  # Name
  validates(
    :name,
    presence: true,
    length: { maximum: 50 }
  )

  # Email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.email = email.downcase }
  validates(
    :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: true
  )

  # Password
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_nil: true

  # Session
  attr_accessor :remember_token

  # TODO: talk about this > why digest & new_token can be defined on 'self'
  #       but remember and authenticated? have to be defined
  ##      > methods defined with 'class << self' are only visible to the user_super_class?
  class << self
    # returns the hash digest of the given string
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # NOTE: remember & authenticated? need to interact with the database; digest and new_token do not
  # NOTE: remember is called in the sessions_controller
  def remember
    # ? the user_in_memory.remember_token is set to the result of model:user.new_token THEN persisted to db
    self.remember_token = User.new_token
    # if(
    update_attribute(:remember_digest, User.digest(remember_token))
    # ) then puts 'it worked' else puts "it didn't work" end
    ## it worked
    remember_digest
  end

  def session_token
    remember_digest || remember
  end

  # returns true if the given token matches the remember_digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
