class PostsController < ApplicationController
  rescue_from 'ActiveRecord::RecordNotFound' do
    render json: {errors: {post: 'Not found'}}, status: :not_found
  end

  def create
    @creator = PostCreator.build(post_params)
    if @creator.save
      render partial: 'post', locals: {post: @creator.post}, status: :ok
    else
      render json: {errors: @creator.errors}, status: :unprocessable_entity
    end
  end

  def rate
    @rater = PostRater.build(params[:post_id], params[:value])
    if @rater.save
      render json: {post_average_rating: @rater.ave}, status: :ok
    else
      render json: {errors: @rater.errors}, status: :unprocessable_entity
    end
  end

  def top_ave
    @top_ave_posts = Post.top_ave(params[:amount], params[:q_method])
    render template: 'posts/top_ave', status: :ok
  end

  def dup_ips
    @ips_used_by_multiple_users = Post.ips_used_by_multiple_users
    render json: @ips_used_by_multiple_users, status: :ok
  end

  private
  def post_params
    params.require(:post).permit(:title,
                                 :content,
                                 :author_login,
                                 :author_ip)
  end
end