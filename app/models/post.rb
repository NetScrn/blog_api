class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :ratings, dependent: :destroy

  TOP_AVE_POSTS_QUERY = <<-SQL
    SELECT id, title, content
    FROM posts
    WHERE
      id IN (
        SELECT p.id
        FROM posts p
        JOIN ratings r ON r.post_id = p.id
        GROUP BY p.id
        ORDER BY AVG(r.value) DESC
        LIMIT(?)
      )
  SQL

  IPS_USED_BY_MULTIPLE_USERS_QUERY = <<-SQL
    SELECT
      p.author_ip as ip,
      array_agg(u.login) as logins
    FROM posts p
    JOIN users u ON u.id = p.author_id
    GROUP BY p.author_ip
    HAVING
      ARRAY_LENGTH(ARRAY_AGG(u.login), 1) > 1
  SQL

  def reset_ave_cache
    update_attribute(:ave_cache, ratings.average(:value))
  end

  def self.reset_all_ave_cache
    Post.all.each { |post| post.reset_ave_cache }
  end

  def self.top_ave(amount = 5, q_method = nil)
    q_method == "ave_cache" ? extract_top_ave_posts_ave_cache(amount) :
    extract_top_ave_posts_sql(amount)
  end

  def self.ips_used_by_multiple_users
    result = ActiveRecord::Base.connection.execute(IPS_USED_BY_MULTIPLE_USERS_QUERY)
    result.values.map do |tuple|
      ip_array = tuple[1].delete(/^{/).delete(/}$/).split(',')
      {ip: tuple[0], logins: ip_array}
    end
  end

  private
  def self.extract_top_ave_posts_ave_cache(amount)
    Post.select(:id, :title, :content).order(ave_cache: :desc).limit(amount)
  end

  def self.extract_top_ave_posts_sql(amount)
    find_by_sql([TOP_AVE_POSTS_QUERY, amount])
  end
end
