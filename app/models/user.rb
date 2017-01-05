class User < ApplicationRecord
  has_many :posts, foreign_key: 'author_id', dependent: :destroy

  validates :login, presence: true
end
