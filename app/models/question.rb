class Question < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :user
  has_many :answers, dependent: :destroy
  validates :user, :title, :description, presence: true
end
