# frozen_string_literal: true

class Api::V1::FeedController < ApplicationController
  respond_to :json

  before_action :authenticate_user!

  def index
    followings = current_user.following.map {|following| following.id}

    @followings_posts = Post.where("user_id IN (?)", followings).order(created_at: :desc).limit(index_params_json[:limit]).offset(index_params_json[:offset])

    data = {
      posts:  followings_posts.map {|post|{
        id: post.id,
        image: url_for(post.image),
        likes_amount: post.likes.count,
      }
      }    
    }

    succesful_response(:ok, data)
  end
  

  
  private
  def index_params_json
    params.require(:limit)
    params.require(:offset)

    params.permit(:limit, :offset)
  end
end
