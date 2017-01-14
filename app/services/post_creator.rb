class PostCreator
  attr_reader :post, :errors

  def self.build(params)
    new(params)
  end

  def initialize(params)
    @user_login = params.delete(:author_login)
    @post_attrs = params
    @errors = {}
  end

  def save
    @post = Post.new(@post_attrs)
    @post.author = get_user(@user_login)
    validate
    errors.any? ? false : post.save
  end

  private
  # return nil if login invalid, return user if it exists else create and return new user
  def get_user(login)
    user = User.find_by(login: login) unless login.blank?
    user ? user : User.new(login: login)
  end

  def validate
    # User validation
    @errors.update({author: {login: ["can't be blank"]}}) if @user_login.blank?
    # Post validation
    if @post_attrs[:title].blank? && @post_attrs[:content].blank?
      @errors.update({post: {title: ["can't be blank"], content: ["can't be blank"]}})
    elsif @post_attrs[:title].blank?
      @errors.update({post: {title: ["can't be blank"]}})
    elsif @post_attrs[:content].blank?
      @errors.update({post: {content: ["can't be blank"]}})
    end
  end
end