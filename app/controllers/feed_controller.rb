class FeedController < ApplicationController
  before_action :authenticate_user!

  def index
    followings = current_user.following.map {|following| following.id}

    @followings_posts = Post.where("user_id IN (?)", followings).order(created_at: :desc)

    @owners = @followings_posts.map {|post| User.find(post.user_id)}
        
  end  
end
