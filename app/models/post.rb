class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :ratings, dependent: :destroy

  def reset_ave_cache
    update_attribute(:ave_cache, ratings.average(:value))
  end

  def self.top_ave(amount = 5)
    select(:id, :title, :content).order(ave_cache: :desc).limit(amount)
  end
end
