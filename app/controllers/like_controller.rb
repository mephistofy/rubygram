class LikeController < ApplicationController
  before_action :authenticate_user!

  def create 
    like = Like.find_by(post_id: create_params[:post_id], user_id: current_user.id)
      
    post = Post.find(create_params[:post_id])
    if like == nil 
      like = post.likes.build(user_id: current_user.id)
      
      if like.save
        redirect_to controller: 'post', action: 'show', id: post.id
      else
        @error = like.errors.full_messages
        redirect_to controller: 'post', action: 'show', id: post.id, error: @error
        
      end
    else 
      like.destroy

      redirect_to controller: 'post', action: 'show', id: post.id

    end
  end
  
  private 
  def create_params
    params.require(:post_id)
    params.permit(:post_id)
  end
end
