class CommentController < ApplicationController
  before_action :authenticate_user!
  before_action :get_post, only: [:create]

  def show
    @comment_id = show_delete_params[:comment_id]
  end
  #POST create_comment
  def create
    comment = @post.comment.build(author_id: current_user.id, comment: create_params_html[:comment])
  
    if comment.save
      respond_to do |format|
        format.html {
          redirect_to controller: 'post', action: 'show', id: @post.id
        }

        format.json {
          render json: {}, status: :ok
        }
      end

    else
      @error = 'Comment save failed'

      respond_to do |format|
          format.html {
            redirect_to controller: 'post', action: 'show', id: @post.id, error: @error
          }

          format.json {
            render json: { error: "comment save failed " }, status: 500
          }
      end
    end
  end

  def update
    comment = Comment.find(update_params[:comment_id])

    if comment.author_id == current_user.id
      comment.comment = update_params[:new_comment]
      comment.save
   
      respond_to do |format|
          format.html {
            redirect_to controller: 'post', action: 'show', id: comment.post_id
          }

          format.json {
            render json: {}, status: :ok
          }
      end
    else
      @error = 'Only the same author that left a comment can edit it'

      respond_to do |format|
          format.html {
            redirect_to controller: 'post', action: 'show', id: comment.post_id
          }
          format.json {
            render json: { error: @error }, status: :bad_request
          }
      end
    end
  end

  #DELETE delete_comment
  def destroy
    comment = Comment.find(show_delete_params[:comment_id])

    if comment.author_id == current_user.id
      comment.destroy
     
      respond_to do |format|
          format.html {
            redirect_to controller: 'post', action: 'show', id: comment.post_id
          }

          format.json {
            render json: {}, status: :ok
          }
      end
    else
      @error = 'Only the same author that left a comment can delete it'
      
      respond_to do |format|
        format.html {
          redirect_to controller: 'post', action: 'show', id: comment.post_id
        }
        format.json {
          render json: { error:  @error }, status: :bad_request
        }
        end
    end
  end

  private 
  def get_post
    @post = Post.find(create_params_html[:post_id])
  end

  def create_params_html
    params.require(:comment_form).permit(:comment, :post_id)
  end

  def update_params
    params.require(:comment).permit(:comment_id, :new_comment)
  end

  def show_delete_params
    params.require(:comment_id)
    params.permit(:comment_id)
  end
end