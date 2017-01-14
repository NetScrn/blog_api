class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :ratings, dependent: :destroy

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

  def self.top_ave(amount = 5)
    select(:id, :title, :content).order(ave_cache: :desc).limit(amount)
  end

  def self.ips_used_by_multiple_users
    result = ActiveRecord::Base.connection.execute(IPS_USED_BY_MULTIPLE_USERS_QUERY)
    result.values.map do |tuple|
      ip_array = tuple[1].sub(/^{/, '').sub(/}$/, '').split(',')
      {ip: tuple[0], logins: ip_array}
    end
  end
end
