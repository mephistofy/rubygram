# frozen_string_literal: true

class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  before_action :find_user, only: :create

  def create 
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user
      
      data = {
        user: {
          id: @user.id
          email: @user.email, 
        }
      }

      succesful_response_api(:ok, data)
    else 
      failed_response(:unauthorized, 'Wrong email or password')

    end
  end

  def destroy
    super
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
  
  def find_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])

    if @user == nil
      failed_response(:unauthorized, 'Wrong email or password')
    end
  end
end
