# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || feed_url
  end

  def after_sign_out_path_for(resource)
    stored_location_for(resource) || sign_in_url
  end

  def succesful_response_api(status, data)
    render json: { data: data }, status: status
  end

  def failed_response_api(status, error)
    case error.class.to_s
    when 'String'
      render json: { error: error }, status: status

    when 'Array'
      render json: { errors: error.map { |msg| { error: msg } } }, status: status

    else
      render json: { error: 'Wrong error type' }, status: status

    end
  end
end
