class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || my_posts_url
  end

  def after_sign_out_path_for(resource)
    stored_location_for(resource) || sign_in_url
  end
end
