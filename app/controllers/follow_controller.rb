class FollowController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
    
  def create
    if current_user.id == @user.id
      @error = 'You cannot follow/unfollow yourself!' 

      action = redirect_to controller: 'user', action: 'show', user_id: @user.id, error: @error

      failed_response(@error, :bad_request, action)

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
      action = nil

      succesful_response(:ok, action, nil)
      
    when 'following'
      @result = @user.following

      action = nil

      succesful_response(:ok, action, nil)

    else
      @error = 'Wrong parametr transmitted'

      action = redirect_to controller: 'user', action: 'show', user_id: @user.id, error: @error
      failed_response(@error, :bad_request, action)

    end
  end


  private
  def render_message(status)

    if status == true
      action = redirect_to controller: 'user', action: 'show', user_id: @user.id
      succesful_response(:ok, action, nil)

    else

      @error = 'Operation failed'
      action = redirect_to controller: 'user', action: 'show', user_id: @user.id, error: @error
      failed_response(@error, 500, action)
    end
  end

  def find_user
    params.require(:user_id)
    params.permit(:user_id)

    @user = User.find(params[:user_id])

    if @user == nil
      @error = 'No such user!'
      action = nil
      failed_response(@error, 404, nil )
    end        
  end

  def show_params
    params.require(:method)
    params.permit(:method)
  end
end
