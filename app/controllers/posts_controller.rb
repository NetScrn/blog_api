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

  end

  def dup_ips

  end

  private
  def post_params
    params.require(:post).permit(:title,
                                 :content,
                                 :author_login,
                                 :author_ip)
  end
end