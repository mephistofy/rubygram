# frozen_string_literal: true

class UserController < ApplicationController
  before_action :authenticate_user!

  # search user
  def index
    @user = User.find_by(email: params[:search])

    if @user.nil?
      @users = User.all.where.not(id: current_user)
    else
      redirect_to controller: 'user', action: 'show', user_id: @user.id
    end
  end

  def show
    @user = User.find(show_params_html[:user_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to controller: 'feed', action: 'index'
  end

  private

  def show_params_html
    params.require(:user_id)
    params.permit(:user_id)
  end
end
