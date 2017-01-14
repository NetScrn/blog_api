module BlogPostRequestHelpers
  def create_rating_through_http_post(blog_post, value)
    post "/posts/#{blog_post.id}/rate",
         params: { value: value },
         headers: { 'ACCEPT' => 'application/json' }
  end
end

RSpec.configure do |c|
  c.include BlogPostRequestHelpers
end