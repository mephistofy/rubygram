class Api::V1::UserController < ApplicationController
  respond_to :json
  before_action :authenticate_user!

  #search user
  def index
    user = User.find_by(email: search_params_json[:search])

    if user == nil
      user = User.limit(params[:limit]).offset(params[:offset])

      data = {
        users: user.map {|user| {
          id: user.id,
          avatar: user.avatar_url,
          email: user.email
        }}
      }

      succesful_response_api(:ok, data)

    else 
      if user.id == current_user.id
        failed_response_api(204, 'Same as you!')

      else

        data = {
          user: {
            id: user.id,
            avatar: user.avatar,
            email: user.email
          }
        }

        succesful_response_api(:ok, data)
        
      end
    end
  end

  def show
    user = User.find(show_params_json[:user_id])
      
    if user == nil 
      failed_response_api(404, 'No such user!')

    else
      posts = @user.post.limit(show_params_json[:limit]).offset(show_params_json[:offset])

      if show_params_json[:offset] == 0
        data = {
          user: {
            id: user.id,
            avatar: user.avatar_url,
            email: user.email,
            posts: posts.map { |post| {
              id: post.id,
              image: post.image_url,
            }}
          }
        }

        succesful_response_api(:ok, data) 

      else
        data = {
          user: {
            posts: posts.map { |post| {
              id: post.id,
              image: post.image_url,
            }} 
          }
        }

        succesful_response_api(:ok, data)

      end 
    end
  end

  private 
  def index_params_json
    params.require(:limit)
    params.require(:offset)
  end

  def show_params_json
    params.require(:user_id)
    params.require(:limit)
    params.require(:offset)

    params.permit(:user_id, :limit, :offset)
  end

end
