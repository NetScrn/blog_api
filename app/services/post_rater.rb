class PostRater
  attr_reader :errors, :ave

  def self.build(post_id, value)
    post = Post.find(post_id)
    new(post, value)
  end

  def initialize(post, value)
    @post = post
    @value = value
    @errors = {}
  end

  def save
    validate
    if errors.any?
      false
    else
      @post.ratings.create(value: @value)
      @ave = @post.ratings.average(:value)
      @post.update_attribute(:ave_cache, @ave)
    end
  end

  private
  def validate
    unless ('1'..'5').include?(@value) || (1..5).include?(@value)
      @errors.update({value: ['is not included in 1 to 5']})
    end
  end
end