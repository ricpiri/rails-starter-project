class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :tags, :views, :slug

  belongs_to :user
  has_many :answers
end