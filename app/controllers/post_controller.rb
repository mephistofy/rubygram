class PostController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_create_params, only: :create
  before_action :validate_show_destroy_params, only: [:show, :destroy]

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

  #GET show_post
  def show
    if params[:error] != nil
      @error = params[:error]
    end

    @comments = @post.comment.all.order(created_at: :asc)

    @like = Like.find_by(post_id: params[:id], user_id: current_user.id)

    @likes_count = @post.likes.count

    @owner = User.find(@post.user_id)

    @followed_by_current_user = current_user.following?(@owner)
  end

  #DELETE delete_post
  def destroy
    if @post.user_id == current_user.id 
      @post.destroy

      redirect_to 'index'
    
    else
      @error = 'You can destroy only your own posts'
      
      render @post

    end
  end
  
  private
  def validate_show_destroy_params
    if !params.has_key?(:id)
      @error = 'You must specify and id param!'

      redirect_to :back, error: @error

    else
      @post = Post.find(params[:id])

      if @post == nil
        @error = 'Post not found!'

        redirect_to :back, error: @error

      end
    end 
  end 

  def validate_create_params
    if !params.has_key?(:post) && !params.has_key?(:image)
      @error = 'You must select an image!'

      render 'new'

    end 
  end

  def create_params
    params.require(:post).permit(:image)
  end 
end
