class UserController < ApplicationController
  before_action :authenticate_user!

  #search user
  def index
    respond_to do |format| 
      format.html {
        @user = User.find_by(email: params[:search])

        if @user == nil
          @users = User.all.where.not(id: current_user)
        else 
          if @user.id == current_user.id
            redirect_to :controller=>'user',:action=>'show',:user_id=>@user.id
          end
        end
      }

      format.json {
        @user = User.find_by(email: search_params_json[:search])

        if @user == nil
          @user = User.limit(params[:limit]).offset(params[:offset])

          render json: {
            users: @user.map {|user| {
              id: user.id,
              avatar: user.avatar_url,
              email: user.email
            }}
          }
        else 
          if @user.id == current_user.id
            render json: { error: 'Same as you!'}, status: 204
          else
            render json: {
              user: {
                id: @user.id,
                avatar: @user.avatar,
                email: @user.email
              }
            }
          end
        end
      }
    end
  end

  def show
    respond_to do |format|
      format.html {
        @user = User.find(show_params_html[:user_id])

        if @user == nil
          @error = 'No such user!'
        else
          @posts = @user.post.all
        end
      }

      format.json {
        @user = User.find(show_params_json[:user_id])
      
        if @user == nil 
          render json: { error: 'No such user!'}, status: 404
        else
          posts = @user.post.limit(show_params_json[:limit]).offset(show_params_json[:offset])

          if show_params_json[:offset] == 0
            render json: {
              user: {
                id: @user.id,
                avatar: @user.avatar_url,
                email: @user.email,
                posts: posts.map { |post| {
                  id: post.id,
                  image: post.image_url,
                }}
              }
            } 
          else
            render json: {
              user: {
                posts: posts.map { |post| {
                  id: post.id,
                  image: post.image_url,
                }} 
              }
            }
          end 
        end
      }
    end 
  end

  private 
  def index_params_json
    params.require(:limit)
    params.require(:offset)
  end

  def show_params_html
    params.require(:user_id)
    params.permit(:user_id)
  end

  def show_params_json
    params.require(:user_id)
    params.require(:limit)
    params.require(:offset)

    params.permit(:user_id, :limit, :offset)
  end

end
