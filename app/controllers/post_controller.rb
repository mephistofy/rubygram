class PostController < ApplicationController
  before_action :authenticate_user!
  before_action :get_post, only: [:show, :destroy, :get_post_likes]

  def new
  end

  def create
    @post = current_user.post.build(create_params)

    if @post.save!
      respond_to do |format|
        format.html{
          redirect_to @post   
        }

        format.json{
          render json: {}, status: :created
        }
      end
    else
      @error = 'An error occured, post was not created!'

      respond_to do |format|
        format.html{
          render 'new'   
        }

        format.json{
          render json: { error: @error }, status: 500 #internal sever error
        }
      end
    end
  end

  #GET show_post
  def show
    @comment = @post.comment.all.order(created_at: :asc)

    respond_to do |format|
      format.html{}

      format.json{
        render json: {
            id: @post.id,
            image: @post.image_url,
            likes_amount: @post.likes.count
        }, status: :ok 
      }
    end
  end

  #DELETE delete_post
  def destroy
    if @post.user_id == current_user.id 
      @post.destroy

      respond_to do |format|
        format.html{
          redirect_to 'index'
        }
        format.json{
          render json: {}, status: :ok
        }
      end
    else
      @error = 'You can destroy only your own posts'
      respond_to do |format|
        format.html{
          render @post      
        }
        format.json{
          render json: { error: @error }, status: :bad_request
        }
      end
    end
  end
  
  private 
  def create_params
    params.require(:post).permit(:image)
  end

  def show_destroy_params
    params.require(:id)
    params.permit(:id)
  end

  
  def get_post
    @post = Post.find(show_destroy_params[:id])

    if @post == nil
      @error = 'Post not found'
      respond_to do |format|
        format.html {}

        format.json {
          render json: { error: @error }, status: 404
        }
      end 
    end
  end
end
