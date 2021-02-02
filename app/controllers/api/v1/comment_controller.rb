# frozen_string_literal: true

class Api::V1::CommentController < ApplicationController
  respond_to :json

  before_action :authenticate_user!

  #API GET all_comments
  def index
    post = Post.find(index_params_json[:post_id])
    comments = post.comment.limit(index_params_json[:limit]).offset(index_params_json[:offset])

    data = {
      comments: comments.map {|comment| {
        id: comment.id,
        author:  User.find(comment.author_id).map {|user|{
          user_id: user.id,
          email: user.email,
          avatar: user.avatar_url
        }}
      }}
    }

    succesful_response(:ok, data)
  end

  #POST create_comment
  def create
    post = Post.find(create_params_html[:post_id])

    if post != nil
      comment = post.comment.build(author_id: current_user.id, comment: create_params_html[:comment])

      if comment.save

        succesful_response(:ok, nil)
      else
        error = comment.errors.full_messages
        
        failed_response(500, error )
      end
    else
      error = 'Post not found'

      failed_response(404, error )
    end
  end

  def update
    check_and('update')
  end

  #DELETE delete_comment
  def destroy
    check_and('delete')
  end

  private
  def check_and(method)
    comment = (method == 'update') ? Comment.find(update_params[:comment_id]) : Comment.find(show_delete_params[:comment_id]) 
    
    if comment.author_id == current_user.id
      case method
      when 'update'
        comment.comment = update_params[:new_comment]
      
        if comment.save
          succesful_response(:ok, nil)
        else
          error = comment.errors.full_messages

          failed_response(500, error )

        end
      when 'delete'
        comment.destroy
        
        succesful_response(:ok, nil)
      else
        error = 'Undefined method'

        failed_response(500, error )
      end

    else
      error = 'Only the same author that left a comment can edit it'

      failed_response(:bad_request, error )
    end
  end

  def update_params
    params.require(:comment).permit(:comment_id, :new_comment)
  end

  def show_delete_params
    params.require(:comment_id)
    params.permit(:comment_id)
  end

  def index_params_json
    params.require(:post_id)
    params.require(:limit)
    params.require(:offset)

    params.permit(:post_id, :limit, :offset)
  end
end