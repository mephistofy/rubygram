class PostController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_create_params, only: :create
  before_action :validate_show_destroy_params, only: [:show, :destroy]

  def new
  end

  def create
    @post = current_user.post.build(create_params)

    if @post.save
      action = redirect_to @post
      data = nil

      succesful_response(:created, action, data)

    else
      @error = @post.errors.full_messages
      action = render 'new'

      failed_response(@error, 500, action)

    end
  end

  #GET show_post
  def show
    #Rails.logger.info('fdfdf')
    if params[:error] != nil
      @error = params[:error]
      #Rails.logger.info(@error)
    end
    @comments = @post.comment.all.order(created_at: :asc)

    @like = Like.find_by(post_id: params[:id], user_id: current_user.id)

    @likes_count = @post.likes.count

    @owner = User.find(@post.user_id)

    action = nil

    @followed_by_current_user = current_user.following?(@owner)

    data = {
      id: @post.id,
      image: @post.image_url,
      likes_count: @post.likes.count,
      liked_by_user: @like != nil ? true : false,
      owner: {
        id: @owner.id,
        avatar: @owner.avatar,
        followed_by_current_user: @followed_by_current_user 
      }
    }

    succesful_response(:ok, action, data)

  end

  #DELETE delete_post
  def destroy
    if @post.user_id == current_user.id 
      @post.destroy

      action = redirect_to 'index'
      succesful_response(:ok, action)
    
    else
      @error = 'You can destroy only your own posts'
      action = render @post

      failed_response(@error, :bad_request, action)
    end
  end
  
  private
  def validate_show_destroy_params
    if !params.has_key?(:id)
      @error = 'You must specify and id param!'

      action = redirect_to :back, error: @error

      failed_response(@error, :bad_request, action)

    else
      @post = Post.find(params[:id])

      if @post == nil
        @error = 'Post not found!'

        action = redirect_to :back, error: @error

        failed_response(@error, 404, action)
      end
    end 
  end 

  def validate_create_params
    if !params.has_key?(:post) && !params.has_key?(:image)
      @error = 'You must select an image!'

      action = render 'new'

      failed_response(@error, :bad_request, action)
    end 
  end

  def create_params
    params.require(:post).permit(:image)
  end 
end
