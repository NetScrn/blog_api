class PostRater
  attr_reader :errors, :ave

  def self.build(post_id, value)
    errors = validate(value)
    return new(nil, nil, errors) if errors.any?
    post = Post.find(post_id)
    new(post, value)
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
      PostAveCountUpdateJob.perform_later @post, @ave
    end
  end

  private
  def self.validate(value)
    unless ('1'..'5').include?(value) || (1..5).include?(value)
      {value: ['is not included in 1 to 5']}
    else
      Hash.new
    end
  end
end