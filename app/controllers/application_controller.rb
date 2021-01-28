class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || feed_url
  end

  def after_sign_out_path_for(resource)
    stored_location_for(resource) || sign_in_url
  end

  def succesful_response(status, action, data)
    respond_to do |format|
      format.html {
        action
      }

      format.json {
        render json: {}, status: status
      }
    end
  end
  
  def failed_response(error, status, action)
    case error.class.to_s
    when 'String'
      respond_to do |format|
        format.html {
          action
        }

        format.json {
          render json: { error: error }, status: status
        }
      end
    
    when 'Array'
      respond_to do |format|
        format.html {
          action
        }

        format.json {
          render json: { errors: error.map {|error| { error: error }} }, status: status
        }
      end
    else
      respond_to do |format|
        format.html {
          action
        }

        format.json {
          render json: { error: 'Wrong error type' }, status: status
        }
      end
    end 
  end 
end
