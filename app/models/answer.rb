class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :question, :user, :body, presence: true
end