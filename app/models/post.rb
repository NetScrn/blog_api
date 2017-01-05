class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :ratings, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
end
