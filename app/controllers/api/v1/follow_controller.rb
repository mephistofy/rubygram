# frozen_string_literal: true

class Api::V1::FollowController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :find_user
    
  def create
    if current_user.id == @user.id
      error = 'You cannot follow/unfollow yourself!' 

      failed_response(:bad_request, error)

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

      data = nil

      succesful_response(:ok, action, data
      
    when 'following'
      @result = @user.following

      data = nil

      succesful_response(:ok, action, data)

    else
      error = 'Wrong parametr transmitted'

      failed_response(:bad_request, error)

    end
  end


  private
  def render_message(status)

    if status == true
      data = nil

      succesful_response(:ok, data)

    else
      error = 'Operation failed'

      failed_response(500, error)

    end
  end

  def find_user
    params.require(:user_id)
    params.permit(:user_id)

    @user = User.find(params[:user_id])

    if @user == nil
      error = 'No such user!'
     
      failed_response(404, error)
    end        
  end

  def show_params
    params.require(:method)
    params.permit(:method)
  end
end
