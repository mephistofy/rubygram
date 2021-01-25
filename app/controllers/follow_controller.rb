class FollowController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
    
  def create
    if current_user.id == @user.id
      @error = 'You cannot follow/unfollow yourself!' 
      respond_to do |format|
          format.html {
            redirect_to controller: 'user', action: 'show', id: @user.id, error: @error
          }

          format.json {
            render json: { error: @error }, status: :bad_request
          }
      end
    else
      if current_user.following?(@user)
        current_user.unfollow(@user)

        status = current_user.following?(@user) ? false : true 
        render_message(status)
      else
        current_user.follow(@user) 

        status = current_user.following?(@user) ? true : false
        render_message(status)
      end
    end
  end

  private
  def render_message(status)
    if status == true
      respond_to do |format|
          format.html {
            redirect_to controller: 'user', action: 'show', id: @user.id
          }

          format.json {
            render json: {},status: :ok
          }
      end 

    else
      @error = 'Operation failed'

      respond_to do |format|
        format.html {
          redirect_to controller: 'user', action: 'show', id: @user.id, error: @error
        }

        format.json {
          render json: { error: @error },status: 500
        }
      end
    end
  end

  def find_user
    params.require(:user_to_be_followed_id)
    params.permit(:user_to_be_followed_id)

    @user = User.find(params[:user_to_be_followed_id])

    if @user == nil
      respond_to do |format|
          format.html { 
            
          }
          format.json {
            render json: { error: 'No such user!'}, status: 404 
          }
      end
    end        
  end
end
