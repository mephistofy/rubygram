class LikeController < ApplicationController
  before_action :authenticate_user!

  def create 
    like = Like.find_by(post_id: create_params[:post_id], user_id: current_user.id)
      
    post = Post.find(create_params[:post_id])
    if like == nil 
      like = post.likes.build(user_id: current_user.id)
      
      if like.save!
        respond_to do |format|
            format.html {
              redirect_to controller: 'post', action: 'show', id: post.id
            }
            format.json {
              render json: {}, status: :ok
            }
        end
      else
        error = 'Like not saved'

        respond_to do |format|
            format.html {
              redirect_to controller: 'post', action: 'show', id: post.id, error: error
            }
            format.json {
              render json: { error: error }, status: 500 
            }
        end   
      end
    else 
      like.destroy

      respond_to do |format|
          format.html {
            redirect_to controller: 'post', action: 'show', id: post.id
          }
          format.json {
            render json: {}, status: :ok
          }
      end
    end
  end
  
  private 
  def create_params
    params.require(:post_id)
    params.permit(:post_id)
  end
end
