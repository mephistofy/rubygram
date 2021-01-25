class FollowController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
    
  def create
    if current_user.id == @user.id 
      render json: { error: 'You cannot follow/unfollow yourself !'}, status: :bad_request
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
      render json: {},status: :ok

    else
      render json: { error: 'operation failed' },status: 500

    end
  end

  def find_user
    params.require(:user_to_be_followed)
    params.permit(:user_to_be_followed)

    @user = User.find(params[:user_to_be_followed])

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
