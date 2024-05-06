class User < ApplicationRecord
  has_secure_password
  validates :password,presence: true, length: { minimum: 6 }
  validates :email,presence: true
  validates :full_name, presence: true
  validates :country_code, presence: true
  validates :mobile_number, presence: true, uniqueness: true

  attr_accessor :full_name, :country_code, :mobile_number


end
