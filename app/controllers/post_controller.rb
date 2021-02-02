# frozen_string_literal: true

class PostController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_create_params, only: :create
  before_action :find_post, only: [:show, :destroy]

  def new
  end

  def create
    @post = current_user.post.build(create_params)

    if @post.save
      redirect_to @post
    else
      @error = @post.errors.full_messages

      render 'new'
    end
  end

  # GET show_post
  def show
    if !params[:error].nil?
      @error = params[:error]
    end

    @comments = @post.comment.all.order(created_at: :asc)

    @like = Like.find_by(post_id: params[:id], user_id: current_user.id)

    @likes_count = @post.likes.size

    @owner = User.find(@post.user_id)

    @followed_by_current_user = current_user.following?(@owner)
  end

  # DELETE delete_post
  def destroy
    if @post.user_id == current_user.id
      @post.destroy
    end

    redirect_to controller: 'user', action: 'show', user_id: current_user.id
  end

  private

  def show_destroy_params
    params.require(:id)
    params.permit(:id, :error)
  end

  def find_post
    @post = Post.find(show_destroy_params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = "Wrong post id"

    redirect_to controller: 'feed', action: 'index'
  end

  def validate_create_params
    if !params.key?(:post) && !params.key?(:image)
      @error = 'You must select an image!'

      render 'new'
    end
  end

  def create_params
    params.require(:post).permit(:image)
  end
end
