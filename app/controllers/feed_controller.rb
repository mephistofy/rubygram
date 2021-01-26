class FeedController < ApplicationController
  before_action :authenticate_user!

  def index
    followings = current_user.following.map {|following| following.id}

    respond_to do |format|
        format.html {
          @followings_posts = Post.where("user_id IN (?)", followings).order(created_at: :desc)

          @owners = @followings_posts.map {|post| User.find(post.user_id)}
        }

        format.json {
          @followings_posts = Post.where("user_id IN (?)", followings).order(created_at: :desc).limit(index_params_json[:limit]).offset(index_params_json[:offset])

          render json: {
            posts:  followings_posts.map {|post|{
                                                  id: post.id,
                                                  image: url_for(post.image),
                                                  likes_amount: post.likes.count,
                                                }
                                         }    
          }
        }
    end
    

  end
  
  private
  def index_params_json
    params.require(:limit)
    params.require(:offset)

    params.permit(:limit, :offset)
  end
end
