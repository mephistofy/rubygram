class RegistrationController < ApplicationController
  def new
  end
  # POST /sign_up
  def create
    @user = User.find_by(email: params[:email])

    if @user != nil
      @error = 'User already exists!'
      
      render 'new'
    else
      user = User.new(get_registration_params)

      if user.save
        redirect_to sign_in_path
      
      else
        @error = user.errors.full_messages

        render 'new'
      end
    end 
  end
   
  private
  def get_registration_params
    params.require(:user).permit(:email, :password, :password_confirmation, :avatar)
  end
end
