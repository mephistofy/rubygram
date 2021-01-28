class RegistrationController < ApplicationController
  before_action :user_exist?, only: :create

  def new
  end
  # POST /sign_up
  def create
    user = User.new(get_registration_params)

    if user.save
      redirect_to sign_in_path
      
    else
      @error = user.errors.full_messages

      render 'new'
        
    end
  end
   
  private
  def get_registration_params
    params.require(:user).permit(:email, :password, :password_confirmation, :avatar)
  end

  def user_exist?
    @user = User.find_by(email: params[:email])

    if @user != nil
      @error = 'User already exists!'
      
      render 'new'

    end  
  end
end
