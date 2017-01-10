class PostAveCountUpdateJob < ApplicationJob
  queue_as :default

  def perform(post, value)
    post.update_attribute(:ave_cache, value)
  end
end
