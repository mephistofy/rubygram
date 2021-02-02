# frozen_string_literal: true

class LikeController < ApplicationController
  before_action :authenticate_user!

  def create
    post_id = create_params[:post_id]

    like = Like.find_by(post_id: post_id, user_id: current_user.id)

    if like.nil?
      like = Like.new(user_id: current_user.id, post_id: post_id)

      if like.save
        redirect_to controller: 'post', action: 'show', id: post_id
      else
        @error = like.errors.full_messages

        redirect_to controller: 'post', action: 'show', id: post_id, error: @error
      end
    else
      like.destroy

      redirect_to controller: 'post', action: 'show', id: like.post_id
    end
  end

  private

  def create_params
    params.require(:post_id)
    params.permit(:post_id)
  end
end
