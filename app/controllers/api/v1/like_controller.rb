# frozen_string_literal: true

class Api::V1::LikeController < ApplicationController
  respond_to :json

  before_action :authenticate_user!

  def create 
    like = Like.find_by(post_id: create_params[:post_id], user_id: current_user.id)
      
    post = Post.find(create_params[:post_id])
    if like == nil 
      like = post.likes.build(user_id: current_user.id)
      
      if like.save!
        data = nil

        succesful_response(:ok, data)
  
      else
        error = 'Like not saved'

        failed_response(500, error)
        
      end
    else 
      like.destroy

      data = nil

      succesful_response(:ok, data)

    end
  end
  
  private 
  def create_params
    params.require(:post_id)
    params.permit(:post_id)
  end
end
