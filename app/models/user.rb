class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: true, presence: true
  validates_email_format_of :email, message: "Invalid email address. Valid e-mail can contain only latin letters, numbers, '@' and '.'"

  has_many :user_account_accesses
  has_many :accounts, through: :user_account_accesses
  has_many :questions
end
