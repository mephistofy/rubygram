# frozen_string_literal: true

class Api::V1::RegistrationController < ApplicationController
  respond_to :json

  before_action :user_exist?, only: :create

  # POST /sign_up
  def create
    user = User.new(get_registration_params)

    if user.save
      data = nil

      succesful_response(:created, data)
    else
      error = user.errors.full_messages

      failed_response(:unauthorized, error)
    end
  end


   
  private
  def get_registration_params
    params.require(:user)

    if params[:avatar] != nil
      params[:avatar] = Base64.decode64(params[:avatar])
    end

    params.permit(:email, :password, :password_confirmation, :avatar)
  end

  def user_exist?
    user = User.find_by(email: params[:email])

    if user != nil
      error = 'User already exists!'
 
      failed_response(:400, error)
    end  
  end
end
