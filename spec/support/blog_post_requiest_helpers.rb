module BlogPostRequestHelpers
  def create_rating_through_http_post(blog_post, value)
    post "/posts/#{blog_post.id}/rate",
         params: { value: value },
         headers: { 'ACCEPT' => 'application/json' }
  end

  def create_blog_post_through_http_post(attributes)
    post "/posts",
         params: {
           post: {title: attributes.fetch(:title),
                        content: attributes.fetch(:content),
                        author_login: attributes.fetch(:author_login),
                        author_ip: attributes.fetch(:author_ip)
           }
         },
         headers: { 'ACCEPT' => 'application/json' }
  end
end

RSpec.configure do |c|
  c.include BlogPostRequestHelpers
end