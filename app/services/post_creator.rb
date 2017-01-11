class PostCreator
  attr_reader :post, :errors

  def self.build(params)
    errors = validate(params)
    return new(nil, errors) if errors.any?

    login = params.delete(:author_login)
    user = get_user(login)
    post = Post.new(params)
    # if ip should be taken from request
    # post.author_ip = request.remote_ip
    post.author = user
    new(post)
  end

  def initialize(post, errors = {})
    @post = post
    @errors = errors
  end

  def save
    errors.any? ? false : post.save
  end

  private
  # return nil if login invalid, return user if it exists else create and return new user
  def self.get_user(login)
    user = User.find_by(login: login)
    !user ? User.new(login: login) : user
  end

  def self.validate(params)
    {}.tap do |errors|
      errors.update({author: {login: ["can't be blank"]}}) if params[:author_login].blank?
      if params[:title].blank? && params[:content].blank?
        errors.update({post: {title: ["can't be blank"], content: ["can't be blank"]}})
      elsif params[:title].blank?
        errors.update({post: {title: ["can't be blank"]}})
      elsif params[:content].blank?
        errors.update({post: {content: ["can't be blank"]}})
      end
    end
  end
end