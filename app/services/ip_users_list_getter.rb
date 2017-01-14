class IpUsersListGetter
  IPS_USED_BY_MULTIPLE_USERS_QUERY = <<-SQL
    SELECT
      p.author_ip as ip,
      string_agg(u.login, ',') as logins
    FROM posts p
    JOIN users u ON u.id = p.author_id
    GROUP BY p.author_ip
    HAVING
      COUNT(*) > 1
  SQL

  def self.ips_used_by_multiple_users
    result = ActiveRecord::Base.connection.execute(IPS_USED_BY_MULTIPLE_USERS_QUERY)
    result.values.map do |tuple|
      ip_array = tuple[1].split(',').uniq
      {ip: tuple[0], logins: ip_array}
    end
  end
end