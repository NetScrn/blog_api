class PostsController < ApplicationController

  def create
    @creator = PostCreator.build(post_params)
    if @creator.save
      render partial: 'post', locals: {post: @creator.post}, status: :ok
    else
      render json: {errors: @creator.errors}, status: :unprocessable_entity
    end
  end

  def rate

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