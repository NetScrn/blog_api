class IpUsersListController
  IPS_USED_BY_MULTIPLE_USERS_QUERY = <<-SQL
    SELECT
      ip,
      string_agg(login, ',') as logins
    FROM ips_logins
    GROUP BY ip
    HAVING
      COUNT(*) > 1
  SQL

  def self.ips_used_by_multiple_users
    result = ActiveRecord::Base.connection.execute(IPS_USED_BY_MULTIPLE_USERS_QUERY)
    result.values.map do |tuple|
      logins_array = tuple[1].split(',').uniq
      {ip: tuple[0], logins: logins_array}
    end
  end

  def self.add_ip_login_pair(post, login)
    conn = ActiveRecord::Base.connection
    ip = conn.quote(post.author_ip)
    login = conn.quote(login)
    post_id = post.id
    query = "INSERT INTO ips_logins (ip, login, post_id) VALUES (%s, %s, %s)" % [ip, login, post_id]
    conn.execute(query)
  end

  # def self.delete_ip_login_pair(post_id)
  #   query = "DELETE FROM ips_logins WHERE post_id = #{post_id}"
  #   ActiveRecord::Base.connection.execute(query)
  # end
end