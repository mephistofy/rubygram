class CommentController < ApplicationController
  before_action :authenticate_user!

  def show
    @comment_id = show_params[:comment_id]
  end
  #POST create_comment
  def create
    post_id = create_params_html[:post_id]

    comment = Comment.new(author_id: current_user.id, comment: create_params_html[:comment], post_id: post_id)

    if comment.save

      action_succesfull_response(post_id)
    else
      error = comment.errors.full_messages
        
      action_failed_response(post_id, error)
    end
  end

  def update
    comment = Comment.find(update_params[:comment_id])

    if comment.author_id == current_user.id 
      comment.comment = update_params[:new_comment]
      
      if comment.save
        action_succesfull_response(comment.post_id)
      else
        error = comment.errors.full_messages

        action_failed_response(comment.post_id, error)
      end
    else
      error = 'Only the same author that created a comment can update it'

      action_failed_response(comment.post_id, error)
    end

  rescue ActiveRecord::RecordNotFound
    error = 'Comment not found'

    action_failed_response(update_params[:post_id], error)  
  end

  #DELETE delete_comment
  def destroy
    comment = Comment.find(delete_params[:comment_id]) 

    if comment.author_id == current_user.id
      comment.destroy
        
      action_succesfull_response(comment.post_id)
    else
      error = 'Only the same author that created a comment can delete it'

      action_failed_response(comment.post_id, error)
    end


  rescue ActiveRecord::RecordNotFound
    error = 'Comment not found'

    action_failed_response(delete_params[:post_id], error)  
  end

  private
  def action_failed_response(id, error)
    redirect_to controller: 'post', action: 'show', id: id, error: error
  end

  def action_succesfull_response(id)
    redirect_to controller: 'post', action: 'show', id: id
  end

  def create_params_html
    params.require(:comment_form).permit(:comment, :post_id)
  end

  def update_params
    params.require(:comment).permit(:comment_id, :new_comment, :post_id)
  end

  def show_params
    params.require(:comment_id)
    params.permit(:comment_id)
  end

  def delete_params
    params.require(:comment_id)
    params.permit(:comment_id, :post_id)
  end

end