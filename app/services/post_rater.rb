class PostRater
  attr_reader :post, :value, :errors, :ave

  def self.build(post_id, value)
    post = Post.find(post_id)
    if ('1'..'5').include?(value) || (1..5).include?(value)
      new(post, value)
    else
      new(nil, nil, {value: ['is not included in 1 to 5']})
    end
  end

  def initialize(post, value, errors = {})
    @post = post
    @value = value
    @errors = errors
  end

  def save
    if errors.any?
      false
    else
      @post.ratings.create(value: @value)
      @ave = @post.ratings.average(:value)
    end
  end
end