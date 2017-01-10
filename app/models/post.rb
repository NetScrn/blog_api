class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :ratings, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  TOP_AVE_POSTS_QUERY = <<-SQL
    SELECT
      title,
      content
    FROM
      posts
    WHERE
      id IN (
        SELECT
          p.id
        FROM
          posts p
        JOIN ratings r ON r.post_id = p.id
        GROUP BY
          p.id
        ORDER BY
          AVG(r.value) DESC
        LIMIT(?)
      )
  SQL

  def self.top_ave(amount, q_method = nil)
    if q_method == :ave_cache
      extract_top_ave_posts_ave_cache(amount)
    else
      extract_top_ave_posts_sql(amount)
    end
  end

  private
  def self.extract_top_ave_posts_ave_cache(amount)
    # todo
  end

  def self.extract_top_ave_posts_sql(amount)
    find_by_sql([TOP_AVE_POSTS_QUERY, amount])
  end
end
