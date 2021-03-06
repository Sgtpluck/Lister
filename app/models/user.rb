class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /@/, message: "is not a valid address" }
  validates :password, presence: true, length:{ minimum: 6, message: "must be at least 6 characters"}
  has_many :lists
end
