class FollowController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
    
  def create
    if current_user.id == @user.id
      @error = 'You cannot follow/unfollow yourself!' 

      redirect_to controller: 'user', action: 'show', user_id: @user.id, error: @error

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

  def index
    case show_params[:method]
  
    when 'followers'
      @result = @user.followers
      
    when 'following'
      @result = @user.following

    else
      @error = 'Wrong parametr transmitted'

      redirect_to controller: 'user', action: 'show', user_id: @user.id, error: @error

    end
  end


  private
  def render_message(status)

    if status == true
      redirect_to controller: 'user', action: 'show', user_id: @user.id

    else
      @error = 'Operation failed'
      redirect_to controller: 'user', action: 'show', user_id: @user.id, error: @error

    end
  end

  def find_user
    params.require(:user_id)
    params.permit(:user_id)

    @user = User.find(params[:user_id])

    if @user == nil
      @error = 'No such user!'

      redirect_to controller: 'user', action: 'show', user_id: current_user.id, error: @error
    end        
  end

  def show_params
    params.require(:method)
    params.permit(:method)
  end
end
