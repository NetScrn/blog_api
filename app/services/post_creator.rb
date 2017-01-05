class PostCreator
  attr_reader :post, :errors

  def self.build(params)
    login = params.delete(:author_login)

    if user = get_user(login)
      post = Post.new(params)
      post.author = user
      new(post)
    else
      new(post, {author: {login: ["can't be blank"]}})
    end
  end

  def initialize(post, errors = {})
    @post = post
    @errors = errors
  end

  def save
    if errors.any?
      false
    else
      if post.save
        true
      else
        @errors = {post: post.errors}
        false
      end
    end
  end

  private
  # return nil if login invalid, return user if it exists else create and return new user
  def self.get_user(login)
    return nil if login.blank?
    user = User.find_by(login: login)
    !user ? User.new(login: login) : user
  end
end