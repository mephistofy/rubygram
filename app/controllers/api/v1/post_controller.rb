# frozen_string_literal: true

class Api::V1::PostController < ApplicationController
  respond_to :json
  
  before_action :authenticate_user!
  before_action :validate_create_params, only: :create
  before_action :validate_show_destroy_params, only: [:show, :destroy]

  def new
  end

  def create
    post = current_user.post.build(create_params)

    if post.save
      data = nil

      succesful_response(:created, data)

    else
      error = post.errors.full_messages

      failed_response(500, error)

    end
  end

  #GET show_post
  def show
    like = Like.find_by(post_id: params[:id], user_id: current_user.id)

    owner = User.find(@post.user_id)

    followed_by_current_user = current_user.following?(@owner)

    data = {
      id: @post.id,
      image: @post.image_url,
      likes_count: @post.likes.count,
      liked_by_user: like != nil ? true : false,
      owner: {
        id: owner.id,
        avatar: owner.avatar,
        followed_by_current_user: followed_by_current_user 
      }
    }

    succesful_response(:ok, data)

  end

  #DELETE delete_post
  def destroy
    if @post.user_id == current_user.id 
      @post.destroy

      data = nil 
      succesful_response(:ok, data)
    
    else
      error = 'You can destroy only your own posts'

      failed_response(500, error)
    end
  end
  
  private
  def validate_show_destroy_params
    if !params.has_key?(:id)
      error = 'You must specify and id param!'

      failed_response(500, error)

    else
      @post = Post.find(params[:id])

      if @post == nil
        error = 'Post not found!'

        failed_response(404, error)

      end
    end 
  end 

  def validate_create_params
    if !params.has_key?(:post) && !params.has_key?(:image)
      error = 'You must select an image!'

      failed_response(:bad_request, error)

    end 
  end

  def create_params
    params.require(:post).permit(:image)
  end 
end
