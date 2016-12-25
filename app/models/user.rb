class User < ApplicationRecord
  has_many :posts

  validates :login, presence: true,
                    length: {minimum: 3}
end
