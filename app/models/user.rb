# class User < ApplicationRecord
#   validates :name, presence: true, length: { maximum: 50 }
#   before_save self.email.downcase!
#   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
#   validates :email, presence: true, length: { maximum: 255 }, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
#   validates :password, length: { minimum: 6 }
#
#   has_secure_password
# end

class User < ApplicationRecord
  #name
  validates :name, presence: true, length: { maximum: 50 }
  #email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #before_save { self.email = email.downcase! }
  before_save   self.email.downcase!
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  #password
  validates :password, length: { minimum: 6 }, allow_nil: true
  has_secure_password
end
